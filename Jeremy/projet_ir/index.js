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
  RECEPTEUR_STATUS: "recepteur/status"
};

// ================= HTTP + WS ==================
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*" }
});

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
    if (err) {
      console.error('❌ Erreur abonnement MQTT', err);
    } else {
      console.log('📡 Abonné aux topics MQTT');
    }
  });
});

// ================= WEBHOOK ====================
async function sendWebhook(event, data) {
  if (!process.env.WEBHOOK_URL) return;

  try {
    await axios.post(
      process.env.WEBHOOK_URL,
      {
        event,
        timestamp: Date.now(),
        data
      },
      {
        headers: {
          "X-Webhook-Secret": process.env.WEBHOOK_SECRET || "dev"
        }
      }
    );
    console.log(`🔔 Webhook envoyé : ${event}`);
  } catch (err) {
    console.error("❌ Erreur webhook :", err.message);
  }
}

// ================= MQTT MESSAGE ===============
mqttClient.on('message', async (topic, message) => {
  try {
    const payload = JSON.parse(message.toString());
    cache.lastUpdate = new Date();

    // ===== PASSAGE =====
    if (topic === TOPICS.PASSAGE) {

      if (!payload.id) return;
      if (!["ENTREE", "SORTIE"].includes(payload.mode)) return;
      if (!["DEBUT", "FIN"].includes(payload.type)) return;

      const passageMetier = {
        appareil_id: payload.id,
        type: payload.mode,
        date_heure: new Date()
      };

      cache.passage = passageMetier;
      io.emit("passage", passageMetier);

      await savePassage(passageMetier);
      await saveLogPassage(payload);
      sendWebhook("PASSAGE", passageMetier);

      console.log("🚪 Passage enregistré :", passageMetier);
    }

    // ===== OSCILLO BRUT =====
    else if (topic === TOPICS.OSCILLO) {
      cache.oscillo = payload;
      io.emit("oscillo", payload);
      await saveOscillo(payload);
      console.log("📈 Oscillo brut reçu");
    }

    // ===== EMETEUR STATUS =====
    else if (topic === TOPICS.EMETEUR_STATUS) {
      cache.emeteur_status = payload;
      io.emit("emeteur_status", payload);

      await updateAppareil(payload);
      if (payload.bat && payload.bat < 700) {
        sendWebhook("BATTERIE_FAIBLE", payload);
      }

      console.log("🔋 Status émetteur :", payload);
    }

    // ===== RECEPTEUR STATUS =====
    else if (topic === TOPICS.RECEPTEUR_STATUS) {
      cache.recepteur_status = payload;
      io.emit("recepteur_status", payload);
      console.log("📡 Status récepteur :", payload);
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

// ================= SERVER =====================
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);
});

// ================= BDD ========================

// ===== passages (METIER) =====
async function savePassage(passage) {
  await pool.query(
    `INSERT INTO passages (appareil_id, type, date_heure)
     VALUES ($1, $2, $3)`,
    [passage.appareil_id, passage.type, passage.date_heure]
  );
}

// ===== log_passages (TECHNIQUE) =====
async function saveLogPassage(payload) {
  await pool.query(
    `INSERT INTO log_passages (
      capteur_id,
      capteur,
      type_passage,
      mode_passage,
      ts
    )
    VALUES ($1, $2, $3, $4, $5)`,
    [
      payload.id,
      payload.capteur || "UNKNOWN",
      payload.type,
      payload.mode,
      payload.ts || Date.now()
    ]
  );
}

// ===== oscillo =====
async function saveOscillo(payload) {
  await pool.query(
    `INSERT INTO logs_oscillo (appareil_id, payload, timestamp)
     VALUES ($1, $2, NOW())`,
    [payload.id || "UNKNOWN", payload]
  );
}

// ===== update appareils =====
async function updateAppareil(payload) {
  await pool.query(
    `UPDATE appareils
     SET batterie = $1,
         frequence = $2,
         derniere_vu = NOW()
     WHERE id = $3`,
    [payload.bat, payload.freq, payload.id]
  );
}
