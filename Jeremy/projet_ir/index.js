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
      'http://178.32.107.35:3000/webhook/test',
      { event, timestamp: Date.now(), data },
      { headers: { "X-Webhook-Secret": process.env.WEBHOOK_SECRET || "dev" } }
    );

    console.log(`🔔 Webhook envoyé : ${event}`);

  } catch (err) {

    console.error("❌ Erreur webhook :", err.message);

  }

}

// ================= API GO =====================
async function sendToGo(event, data) {

  try {

    await axios.post(
      "http://178.32.107.35:3000/webhook/test",
      { event, timestamp: Date.now(), data }
    );

    console.log(`📤 Envoyé à Gauthier : ${event}`);

  } catch (err) {

    console.error("❌ Erreur envoi Gauthier :", err.message);

  }

}

// ================= MQTT MESSAGE ===============
mqttClient.on('message', async (topic, message) => {

  try {

    if (topic === TOPICS.LED1) {

      const batterie = Number(message.toString());

      if (isNaN(batterie)) {
        console.warn("⚠️ Batterie LED invalide");
        return;
      }

      await saveLedBattery({
        appareil_id: "PORTE_01",
        batterie
      });

      await sendToGo("LED_BATTERY", {
        id: "PORTE_01",
        batterie
      });

      console.log("🔋 Batterie LED enregistrée :", batterie);
      return;

    }

    const payload = JSON.parse(message.toString());
    cache.lastUpdate = new Date();

    // ===== PASSAGE =====
    if (topic === TOPICS.PASSAGE) {

      const passageMetier = {
        appareil_id: payload.id,
        type: payload.type,
        faisceau: payload.faisceau,
        duree: payload.duree
      };

      cache.passage = passageMetier;
      io.emit("passage", passageMetier);

      await ensureAppareilExists(payload.id, payload);
      await savePassage(passageMetier);
      await sendWebhook("PASSAGE", passageMetier);

      console.log("🚪 Passage enregistré :", passageMetier);

    }

    // ===== OSCILLO =====
    else if (topic === TOPICS.OSCILLO) {

      cache.oscillo = payload;
      io.emit("oscillo", payload);

      await ensureAppareilExists(payload.id, payload);
      await saveOscillo(payload);

      console.log("📈 Oscillo brut reçu");

    }

    // ===== STATUS =====
    else if (
      topic === TOPICS.EMETEUR_STATUS ||
      topic === TOPICS.RECEPTEUR_STATUS
    ) {

      const key =
        topic === TOPICS.EMETEUR_STATUS
          ? "emeteur_status"
          : "recepteur_status";

      cache[key] = payload;
      io.emit(key, payload);

      await ensureAppareilExists(payload.id, payload);
      await updateAppareil(payload);

      console.log(`🔋 Status ${key} :`, payload);

    }

    // ===== NDNS DISCOVERY =====
    else if (
      topic === TOPICS.EMETEUR_URL ||
      topic === TOPICS.RECEPTEUR_URL
    ) {

      await ensureAppareilExists(payload.id, payload);

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

      const status = String(payload.status).toUpperCase();
      const position = String(payload.position).toUpperCase();
      const type = String(payload.type).toUpperCase();
      const duree_totale = Number(payload.duree_totale);

      await ensureAppareilExists(payload.id, payload);

      await saveAlerte({
        appareil_id: payload.id,
        status,
        position,
        type,
        duree_totale,
        timestamp: payload.timestamp
      });

      await sendWebhook("ALERTE", payload);

      console.log("✅ Alerte enregistrée");

    }

  } catch (err) {

    console.error("❌ Erreur MQTT :", err.message);

  }

});

// ================= API ========================
app.get('/', (req, res) => {

  res.json({
    status: "API OK",
    lastUpdate: cache.lastUpdate
  });

});

app.get('/api/passage', (req, res) => {

  res.json(cache.passage);

});

// ================= WEBHOOK TEST ===============
app.post('/webhook/test', (req, res) => {

  console.log("🧪 WEBHOOK REÇU :", req.body);
  res.json({ ok: true });

});

// ================= SERVER =====================
server.listen(PORT, '0.0.0.0', () => {

  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);

});

// ================= BDD UTILITY =================
async function queryBoth(query, params, label = "QUERY") {

  console.log(`📥 ${label} → tentative d'insertion`);

  try {

    const resultLocal = await poolLocal.query(query, params);

    console.log(`💾 ${label} → BDD locale OK`);
    console.log(`📊 lignes affectées :`, resultLocal.rowCount);

  } catch (err) {

    console.error(`❌ ${label} → erreur BDD locale :`, err.message);

  }

  try {

    const resultVPS = await poolVPS.query(query, params);

    console.log(`☁️ ${label} → BDD VPS OK`);
    console.log(`📊 lignes affectées :`, resultVPS.rowCount);

  } catch (err) {

    console.error(`❌ ${label} → erreur BDD VPS :`, err.message);

  }

}
// ================= BDD ========================

async function savePassage(payload) {

  const query = `
  INSERT INTO passages (
    appareil_id,
    type,
    faisceau,
    duree,
    date_heure
  )
  VALUES ($1,$2,$3,$4,NOW())
  `;

  const params = [
    payload.appareil_id,
    payload.type,
    payload.faisceau,
    payload.duree
  ];

  console.log("🚪 Nouveau passage :", payload);

  await queryBoth(query, params, "PASSAGE");

}

async function saveOscillo(payload) {

  const query = `
  INSERT INTO logs_oscillo (appareil_id, payload, timestamp)
  VALUES ($1,$2,NOW())
  `;

  await queryBoth(query, [payload.id, payload], "OSCILLO");

}

async function saveLedBattery(payload) {

  const query = `
  INSERT INTO led_battery (appareil_id, batterie, timestamp)
  VALUES ($1,$2,NOW())
  `;

  await queryBoth(query, [
    payload.appareil_id,
    payload.batterie
  ], "LED_BATTERY");

}

async function saveNDNS(payload) {

  const query = `
  INSERT INTO ndns (id, url, type, status, timestamp)
  VALUES ($1,$2,$3,$4,NOW())
  ON CONFLICT (id)
  DO UPDATE SET
    url = EXCLUDED.url,
    type = EXCLUDED.type,
    status = EXCLUDED.status,
    timestamp = NOW()
  `;

  await queryBoth(query, [
    payload.id,
    payload.url,
    payload.type,
    payload.status
  ], "NDNS");

}

async function ensureAppareilExists(appareilId, meta = {}) {

  const query = `
  INSERT INTO appareils (
    id,
    batterie,
    sensibilite,
    frequence,
    role_f,
    role_b,
    timestamp
  )
  VALUES ($1,$2,$3,$4,$5,$6,NOW())

  ON CONFLICT (id) DO UPDATE SET
    batterie = COALESCE(EXCLUDED.batterie, appareils.batterie),
    sensibilite = COALESCE(EXCLUDED.sensibilite, appareils.sensibilite),
    frequence = COALESCE(EXCLUDED.frequence, appareils.frequence),
    role_f = COALESCE(EXCLUDED.role_f, appareils.role_f),
    role_b = COALESCE(EXCLUDED.role_b, appareils.role_b),
    timestamp = NOW()
  `;

  await queryBoth(query, [
    appareilId,
    meta.bat || null,
    meta.sensibilite || null,
    meta.freq || null,
    meta.role_f || null,
    meta.role_b || null
  ], "APPAREIL");

}

async function updateAppareil(payload) {

  const query = `
  UPDATE appareils
  SET batterie = $1,
      frequence = $2,
      derniere_vu = NOW()
  WHERE id = $3
  `;

  await queryBoth(query, [
    payload.bat || null,
    payload.freq || null,
    payload.id
  ], "UPDATE_APPAREIL");

}

async function saveAlerte(payload) {

  const dateEsp = new Date(payload.timestamp * 1000);

  const query = `
  INSERT INTO alertes (
    appareil_id,
    status,
    position,
    type,
    duree_totale,
    timestamp_esp
  )
  VALUES ($1,$2,$3,$4,$5,$6)
  `;

  await queryBoth(query, [
    payload.appareil_id,
    payload.status,
    payload.position,
    payload.type,
    payload.duree_totale,
    dateEsp
  ], "ALERTE");

}