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
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

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

// ================= API GO =================
async function sendToGo(event, data) {

  try {

    await axios.post(
      "http://178.32.107.35:3000/webhook/test",
      {
        event,
        timestamp: Date.now(),
        data
      }
    );

    console.log(`📤 Envoyé au collègue : ${event}`);

  } catch (err) {

    console.error("❌ Erreur envoi collègue :", err.message);

  }

}

// ================= MQTT MESSAGE ===============
mqttClient.on('message', async (topic, message) => {
  try {

    // ===== LED BATTERY =====
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
      if (
        !payload.id ||
        !["ENTREE", "SORTIE"].includes(payload.type) ||
        !["f", "b"].includes(payload.faisceau) ||
        typeof payload.duree !== "number"
      ) return;

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

      if (payload.id) {
        await ensureAppareilExists(payload.id, payload);
        await saveOscillo(payload);
      } else {
        console.warn("⚠️ Oscillo reçu sans id appareil");
      }

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

      if (payload.id) {
        await ensureAppareilExists(payload.id, payload);
        await updateAppareil(payload);
      }

      if (topic === TOPICS.EMETEUR_STATUS && payload.bat && payload.bat < 20) {
        await sendWebhook("BATTERIE_FAIBLE", payload);
      }

      console.log(`🔋 Status ${key} :`, payload);
    }

    // ===== NDNS DISCOVERY =====
    else if (
      topic === TOPICS.EMETEUR_URL ||
      topic === TOPICS.RECEPTEUR_URL
    ) {

      if (!payload.id || !payload.url) {
        console.warn("⚠️ Discovery ignoré : id/url manquant");
        return;
      }

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

      if (!payload.id) {
        console.warn("⚠️ Alerte ignorée : id manquant");
        return;
      }

      const status = String(payload.status).toUpperCase();
      const position = String(payload.position).toUpperCase();
      const type = String(payload.type).toUpperCase();
      const duree_totale = Number(payload.duree_totale);

      if (isNaN(duree_totale)) {
        console.warn("⚠️ Alerte ignorée : durée invalide");
        return;
      }

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

      console.log("✅ Alerte enregistrée en BDD");
    }

  } catch (err) {
    console.error("❌ Erreur MQTT :", err.message);
  }
});

// ================= API ========================
app.get('/', (req, res) => {
  res.json({ status: "API OK", lastUpdate: cache.lastUpdate });
});

app.get('/api/passage', (req, res) => {
  res.json(cache.passage);
});

// ================= WEBHOOK TEST =================
app.post('/webhook/test', (req, res) => {
  console.log("🧪 WEBHOOK REÇU :", req.body);
  res.json({ ok: true, received: req.body });
});

// ================= SERVER =====================
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);
});

// ================= BDD ========================

// ===== passages =====
async function savePassage(payload) {
  await pool.query(
    `INSERT INTO passages (
      appareil_id,
      type,
      faisceau,
      duree,
      date_heure
    )
    VALUES ($1, $2, $3, $4, NOW())`,
    [
      payload.appareil_id,
      payload.type,
      payload.faisceau,
      payload.duree
    ]
  );
}

// ===== oscillo =====
async function saveOscillo(payload) {
  await pool.query(
    `INSERT INTO logs_oscillo (appareil_id, payload, timestamp)
     VALUES ($1, $2, NOW())`,
    [payload.id, payload]
  );
}

// ===== LED BATTERY =====
async function saveLedBattery(payload) {

  await pool.query(
    `INSERT INTO led_battery (appareil_id, batterie, timestamp)
     VALUES ($1, $2, NOW())`,
    [
      payload.appareil_id,
      payload.batterie
    ]
  );

}

// ===== NDNS =====
async function saveNDNS(payload) {

  await pool.query(
    `INSERT INTO ndns (id, url, type, status, timestamp)
     VALUES ($1, $2, $3, $4, NOW())
     ON CONFLICT (id)
     DO UPDATE SET
       url = EXCLUDED.url,
       type = EXCLUDED.type,
       status = EXCLUDED.status,
       timestamp = NOW()`,
    [
      payload.id,
      payload.url,
      payload.type,
      payload.status
    ]
  );

}

// ===== appareils =====
async function ensureAppareilExists(appareilId, meta = {}) {

  if (!appareilId) return;

  await pool.query(
    `INSERT INTO appareils (
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
    `,
    [
      appareilId,
      meta.bat || null,
      meta.sensibilite || null,
      meta.freq || null,
      meta.role_f || null,
      meta.role_b || null
    ]
  );
}

async function updateAppareil(payload) {
  await pool.query(
    `UPDATE appareils
     SET batterie = $1,
         frequence = $2,
         derniere_vu = NOW()
     WHERE id = $3`,
    [
      payload.bat || null,
      payload.freq || null,
      payload.id
    ]
  );
}

// ===== alertes =====
async function saveAlerte(payload) {

  const dateEsp = new Date(payload.timestamp * 1000);

  await pool.query(
    `INSERT INTO alertes (
      appareil_id,
      status,
      position,
      type,
      duree_totale,
      timestamp_esp
    )
    VALUES ($1, $2, $3, $4, $5, $6)`,
    [
      payload.appareil_id,
      payload.status,
      payload.position,
      payload.type,
      payload.duree_totale,
      dateEsp
    ]
  );
}