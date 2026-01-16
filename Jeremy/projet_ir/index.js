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
  status: null,
  config: null,
  lastUpdate: null
};

// ================= MQTT TOPICS ================
const TOPICS = {
  PASSAGE: process.env.MQTT_TOPIC_PASSAGE,
  STATUS: process.env.MQTT_TOPIC_STATUS,
  CONFIG: process.env.MQTT_TOPIC_CONFIG
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

    switch (topic) {

      case TOPICS.PASSAGE: {
        // 🔎 DEBUG (optionnel)
        // console.log("MQTT PASSAGE RAW :", payload);

        // ESP obligatoire
        if (!payload.appareil_id) return;

        // ENTREE / SORTIE
        if (payload.mode !== "ENTREE" && payload.type !== "SORTIE") return;

        // DEBUT / FIN
        if (payload.type_passage !== "DEBUT" && payload.type_passage !== "FIN") return;

        const dbPassage = {
          appareil_id: payload.appareil_id,
          type_passage: payload.type_passage,
          date_heure: payload.date_heure ? new Date(payload.date_heure) : new Date()
        };

        cache.passage = dbPassage;

        io.emit("passage", dbPassage);
        sendWebhook("PASSAGE", dbPassage);
        await savePassage(dbPassage);
        break;
      }

      case TOPICS.STATUS:
        cache.status = payload;
        io.emit("status", payload);
        if (payload.bat && payload.bat < 700) {
          sendWebhook("BATTERIE_FAIBLE", payload);
        }
        break;

      case TOPICS.CONFIG:
        cache.config = payload;
        io.emit("config", payload);
        sendWebhook("CONFIG", payload);
        break;
    }

    console.log(`[MQTT] ${topic} →`, payload);

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

// ================= WEBHOOK TEST =================
app.post('/webhook/test', (req, res) => {
  console.log("🧪 WEBHOOK TEST REÇU :", req.body);
  res.json({ ok: true });
});


// ================= SERVER =====================
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);
});

// ================= BDD ========================
async function savePassage(passage) {
  const query = `
    INSERT INTO passages (
      appareil_id,
      type,
      date_heure,
      type_passage
    )
    VALUES ($1, $2, $3, $4);
  `;

  const values = [
    passage.appareil_id,
    "PASSAGE",
    passage.date_heure,
    passage.type_passage
  ];

  try {
    await pool.query(query, values);
    console.log("💾 Passage enregistré :", passage.appareil_id, passage.type_passage);
  } catch (err) {
    console.error("❌ Erreur BDD :", err.message);
  }
}
