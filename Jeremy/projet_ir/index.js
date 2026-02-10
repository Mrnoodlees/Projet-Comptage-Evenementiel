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



// ================= MQTT MESSAGE ===============
mqttClient.on('message', async (topic, message) => {
  try {
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

      await ensureAppareilExists(payload.id);
      await savePassage(passageMetier);
      await sendWebhook("PASSAGE", passageMetier);

      console.log("🚪 Passage enregistré :", passageMetier);
    }

    // ===== OSCILLO =====
    else if (topic === TOPICS.OSCILLO) {
      cache.oscillo = payload;
      io.emit("oscillo", payload);

      if (payload.id) {
        await ensureAppareilExists(payload.id);
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

      if (topic === TOPICS.EMETEUR_STATUS && payload.bat && payload.bat < 700) {
        await sendWebhook("BATTERIE_FAIBLE", payload);
      }

      console.log(`🔋 Status ${key} :`, payload);
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

// ===== appareils =====
async function ensureAppareilExists(appareilId, meta = {}) {
  if (!appareilId) return;

  await pool.query(
    `INSERT INTO appareils (id, batterie, frequence, derniere_vu)
     VALUES ($1, $2, $3, NOW())
     ON CONFLICT (id) DO NOTHING`,
    [
      appareilId,
      meta.bat || null,
      meta.freq || null
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
