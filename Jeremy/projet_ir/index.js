require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const mqtt = require('mqtt');
const cors = require('cors');
const axios = require('axios');
const http = require('http');
const { Server } = require('socket.io');
const { Pool } = require('pg');

const app = express();
const PORT = 3000;

// ================= MIDDLEWARE =================
app.use(bodyParser.json());
app.use(cors());

// ================= POSTGRES ===================

// ===== POSTGRES VPS =====
const poolVPS = new Pool({
  host: process.env.DB_VPS_HOST,
  port: process.env.DB_VPS_PORT,
  user: process.env.DB_VPS_USER,
  password: process.env.DB_VPS_PASSWORD,
  database: process.env.DB_VPS_NAME
});

// ===== POSTGRES LOCAL =====
const poolLocal = new Pool({
  host: process.env.DB_LOCAL_HOST,
  port: process.env.DB_LOCAL_PORT,
  user: process.env.DB_LOCAL_USER,
  password: process.env.DB_LOCAL_PASSWORD,
  database: process.env.DB_LOCAL_NAME
});

console.log("💾 BDD locale :", process.env.DB_LOCAL_NAME);
console.log("☁️ BDD VPS :", process.env.DB_VPS_NAME);
console.log("🛠️ DB_TARGET =", process.env.DB_TARGET || "all");

console.log("VPS host:", process.env.DB_VPS_HOST, "port:", process.env.DB_VPS_PORT);

(async () => {
  try {
    const res = await poolVPS.query('SELECT NOW()');
    console.log("☁️ VPS connection OK :", res.rows);
  } catch (err) {
    console.error("❌ VPS connection failed :", err.message);
  }
})();
// ================= CACHE ======================
const cache = {
  passage: null,
  emeteur_status: null,
  recepteur_status: null,
  oscillo: null,
  lastUpdate: null
};

// ================= MQTT TOPICS ================
const TOPICS = {
  PASSAGE: "porte/passage",
  OSCILLO: "porte/oscillo/brut",
  EMETEUR_STATUS: "emeteur/status",
  RECEPTEUR_STATUS: "recepteur/status",
  ALERTE: "porte/alerte",
  EMETEUR_URL: "emeteur/discovery",
  RECEPTEUR_URL: "recepteur/discovery",
  LED1: "wled/porte1/battery"
};

// ================= HTTP + WS ==================
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

io.on("connection", (socket) => {
  console.log("🟢 Frontend connecté");
  socket.emit("init", cache);
});

// ================= MQTT =======================
const mqttClient = mqtt.connect(process.env.MQTT_BROKER, {
  username: process.env.MQTT_USER,
  password: process.env.MQTT_PASSWORD
});

mqttClient.on('connect', () => {
  console.log('✅ Connecté au broker MQTT');
  mqttClient.subscribe(Object.values(TOPICS), (err) => {
    if (err) console.error('❌ Erreur abonnement MQTT', err);
    else console.log('📡 Abonné aux topics MQTT');
  });
});

// ================= WEBHOOK ====================
async function sendWebhook(event, data) {
  try {
    await axios.post(
      process.env.WEBHOOK_URL,
      { event, timestamp: Date.now(), data },
      { headers: { "X-Webhook-Secret": process.env.WEBHOOK_SECRET || "dev" } }
    );
    console.log(`🔔 Webhook envoyé : ${event}`);
  } catch (err) {
    console.error("❌ Erreur webhook :", err.stack);
  }
}

// ================= API GO =====================
async function sendToGo(event, data) {
  try {
    await axios.post(
      process.env.WEBHOOK_URL,
      { event, timestamp: Date.now(), data }
    );
    console.log(`📤 Envoyé à Gauthier : ${event}`);
  } catch (err) {
    console.error("❌ Erreur envoi Gauthier :", err.stack);
  }
}

// ================= MQTT MESSAGE ===============
mqttClient.on('message', async (topic, message) => {
  try {
    const msgStr = message.toString();

    if (topic.startsWith("wled")) {
      console.log("💡 WLED message :", msgStr);
      return;
    }

    if (topic === TOPICS.LED1) {
      const batterie = Number(msgStr);
      if (isNaN(batterie)) return console.warn("⚠️ Batterie LED invalide");
      await saveLedBattery({ appareil_id: "PORTE_01", batterie });
      await sendToGo("LED_BATTERY", { id: "PORTE_01", batterie });
      console.log("🔋 Batterie LED enregistrée :", batterie);
      return;
    }

    let payload;
    try { payload = JSON.parse(msgStr); } 
    catch { return console.warn("⚠️ Message non JSON sur", topic); }

    cache.lastUpdate = new Date();

    // ===== PASSAGE =====
    if (topic === TOPICS.PASSAGE) {
      console.log("📨 Payload passage reçu :", payload);
      const passageMetier = {
        appareil_id: payload.id,
        type: payload.type,
        faisceau: payload.faisceau,
        duree: Number(payload.duree)
      };
      console.log("🛠️ Passage formaté :", passageMetier);
      cache.passage = passageMetier;

      io.emit("passage", passageMetier);

      await ensureAppareilExists(passageMetier.appareil_id);
      await savePassage(passageMetier);

      await sendWebhook("PASSAGE", passageMetier);
    }

    // ===== OSCILLO =====
    else if (topic === TOPICS.OSCILLO) {
      cache.oscillo = payload;
      io.emit("oscillo", payload);
      await ensureAppareilExists(payload.id);
      await saveOscillo(payload);
      console.log("📈 Oscillo brut reçu :", payload);
    }

    // ===== STATUS =====
    else if (topic === TOPICS.EMETEUR_STATUS || topic === TOPICS.RECEPTEUR_STATUS) {
      const key = topic === TOPICS.EMETEUR_STATUS ? "emeteur_status" : "recepteur_status";
      cache[key] = payload;
      io.emit(key, payload);
      await ensureAppareilExists(payload.id);
      await updateAppareil(payload);
      console.log(`🔋 Status ${key} :`, payload);
    }

    // ===== NDNS DISCOVERY =====
    else if (topic === TOPICS.EMETEUR_URL || topic === TOPICS.RECEPTEUR_URL) {
      await ensureAppareilExists(payload.id);
      await saveNDNS({
        id: payload.id,
        url: payload.url,
        type: payload.type,
        status: payload.status || null
      });
      await sendToGo("NDNS_DISCOVERY", payload);
      console.log("🌐 NDNS enregistré :", payload);
    }

    // ===== ALERTE =====
    else if (topic === TOPICS.ALERTE) {
      console.log("🚨 ALERTE REÇUE :", payload);
      const status = String(payload.status || "INCONNU").toUpperCase();
      const position = String(payload.position || "INCONNU").toUpperCase();
      const type = String(payload.type || "INCONNU").toUpperCase();
      const duree_totale = Number(payload.duree_totale || 0);
      const timestamp = payload.timestamp ? new Date(payload.timestamp * 1000) : new Date();
      await ensureAppareilExists(payload.id);
      await saveAlerte({ appareil_id: payload.id, status, position, type, duree_totale, timestamp });
      await sendWebhook("ALERTE", payload);
      console.log("✅ Alerte enregistrée");
    }

  } catch (err) {
    console.error("❌ Erreur MQTT :", err.stack);
  }
});

// ================= API ========================
app.get('/', (req, res) => {
  res.json({ status: "API OK", lastUpdate: cache.lastUpdate });
});

app.get('/api/passage', (req, res) => res.json(cache.passage));

app.post('/webhook/test', (req, res) => {
  console.log("🧪 WEBHOOK REÇU :", req.body);
  res.json({ ok: true });
});

// ================= SERVER =====================
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);
});

// ================= BDD FUNCTIONS ========================

// Utilitaire DB cible
function getPools() {
  const target = process.env.DB_TARGET || "all";
  const pools = [];
  if(target === "local" || target === "all") pools.push({ pool: poolLocal, name: "LOCAL" });
  if(target === "vps"   || target === "all") pools.push({ pool: poolVPS, name: "VPS" });
  return pools;
}

async function savePassage(payload) {
  const query = `INSERT INTO passages (appareil_id,type,faisceau,duree,date_heure) VALUES ($1,$2,$3,$4,NOW())`;
  const params = [payload.appareil_id,payload.type,payload.faisceau,Number(payload.duree)];
  for(const {pool,name} of getPools()) {
    try {
      const res = await pool.query(query, params);
      console.log(`💾 PASSAGE ${name} OK`, res.rowCount);
    } catch(err){
      console.error(`❌ PASSAGE ${name} ERROR :`, err.stack, params);
    }
  }
}

async function saveOscillo(payload) {
  const query = `INSERT INTO logs_oscillo (appareil_id, payload, timestamp) VALUES ($1,$2,NOW())`;
  const params = [payload.id, JSON.stringify(payload)];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 OSCILLO ${name} OK`); }
    catch(err){ console.error(`❌ OSCILLO ${name} ERROR :`, err.stack); }
  }
}

async function saveLedBattery(payload) {
  const query = `INSERT INTO led_battery (appareil_id, batterie, timestamp) VALUES ($1,$2,NOW())`;
  const params = [payload.appareil_id, Number(payload.batterie)];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 LED ${name} OK`); }
    catch(err){ console.error(`❌ LED ${name} ERROR :`, err.stack); }
  }
}

async function saveNDNS(payload) {
  const query = `
    INSERT INTO ndns (id,url,type,status,timestamp)
    VALUES ($1,$2,$3,$4,NOW())
    ON CONFLICT (id) DO UPDATE SET url=EXCLUDED.url,type=EXCLUDED.type,status=EXCLUDED.status,timestamp=NOW()
  `;
  const params = [payload.id,payload.url,payload.type,payload.status];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 NDNS ${name} OK`); }
    catch(err){ console.error(`❌ NDNS ${name} ERROR :`, err.stack); }
  }
}

async function ensureAppareilExists(appareilId, meta={}) {
  const query = `
    INSERT INTO appareils (id,batterie,timestamp)
    VALUES ($1,$2,NOW())
    ON CONFLICT (id) DO UPDATE SET batterie=COALESCE(EXCLUDED.batterie,appareils.batterie),timestamp=NOW()
  `;
  const params = [appareilId, meta.bat || null];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 APPAREIL ${name} OK`); }
    catch(err){ console.error(`❌ APPAREIL ${name} ERROR :`, err.stack); }
  }
}

async function updateAppareil(payload) {
  const query = `UPDATE appareils SET batterie=$1, derniere_vu=NOW() WHERE id=$2`;
  const params = [payload.bat ?? null, payload.id];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 UPDATE ${name} OK`); }
    catch(err){ console.error(`❌ UPDATE ${name} ERROR :`, err.stack); }
  }
}

async function saveAlerte(payload) {
  const query = `
    INSERT INTO alertes (appareil_id,status,position,type,duree_totale,timestamp_esp)
    VALUES ($1,$2,$3,$4,$5,$6)
  `;
  const params = [
    payload.appareil_id,
    payload.status,
    payload.position,
    payload.type,
    Number(payload.duree_totale),
    payload.timestamp || new Date()
  ];
  for(const {pool,name} of getPools()) {
    try { await pool.query(query, params); console.log(`💾 ALERTE ${name} OK`); }
    catch(err){ console.error(`❌ ALERTE ${name} ERROR :`, err.stack); }
  }
}