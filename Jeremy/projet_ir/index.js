require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const mqtt = require('mqtt');
const cors = require('cors'); // pour permettre l'accès depuis le site web

const app = express();
const PORT = 3000;

// ===== Middleware =====
app.use(bodyParser.json());
app.use(cors());

// ===== Cache mémoire =====
const cache = {
  passage: null,
  status: null,
  config: null,
  lastUpdate: null
};

// ===== Topics MQTT =====
const TOPICS = {
  PASSAGE: process.env.MQTT_TOPIC_PASSAGE,
  STATUS: process.env.MQTT_TOPIC_STATUS,
  CONFIG: process.env.MQTT_TOPIC_CONFIG
};

// ===== Connexion MQTT =====
const mqttClient = mqtt.connect(process.env.MQTT_BROKER, {
  username: process.env.MQTT_USER || 'leo',   // user du broker
  password: process.env.MQTT_PASSWORD || 'test' // password du broker
});

mqttClient.on('connect', () => {
  console.log('✅ Connecté au broker MQTT');

  mqttClient.subscribe(Object.values(TOPICS), (err) => {
    if (err) {
      console.error('❌ Erreur abonnement MQTT', err);
    } else {
      console.log('📡 Abonné aux topics MQTT :', Object.values(TOPICS));
    }
  });
});

// ===== Réception des messages MQTT =====
mqttClient.on('message', (topic, message) => {
  try {
    const payload = JSON.parse(message.toString()); // Python envoie du JSON
    cache.lastUpdate = new Date();

    switch (topic) {
      case TOPICS.PASSAGE:
        cache.passage = payload;
        break;

      case TOPICS.STATUS:
        cache.status = payload;
        break;

      case TOPICS.CONFIG:
        cache.config = payload;
        break;

      default:
        console.log('⚠️ Topic non géré :', topic);
    }

    console.log(`[MQTT] ${topic} →`, payload);

  } catch (err) {
    console.error('❌ Erreur parsing MQTT :', err.message);
  }
});

// =================================================
// ================== API REST =====================
// =================================================

// Test API
app.get('/', (req, res) => {
  res.json({
    message: 'API MQTT → Web opérationnelle 🚀',
    lastUpdate: cache.lastUpdate
  });
});

// 🔹 Dernier passage détecté
app.get('/api/passage', (req, res) => {
  res.json({
    topic: TOPICS.PASSAGE,
    data: cache.passage,
    lastUpdate: cache.lastUpdate
  });
});

// 🔹 Dernier status
app.get('/api/status', (req, res) => {
  res.json({
    topic: TOPICS.STATUS,
    data: cache.status,
    lastUpdate: cache.lastUpdate
  });
});

// 🔹 Dernière config
app.get('/api/config', (req, res) => {
  res.json({
    topic: TOPICS.CONFIG,
    data: cache.config,
    lastUpdate: cache.lastUpdate
  });
});

// 🔹 Envoyer une config vers l’ESP (via MQTT)
app.post('/api/config', (req, res) => {
  const config = req.body;

  mqttClient.publish(
    TOPICS.CONFIG,
    JSON.stringify(config),
    { qos: 1 },
    (err) => {
      if (err) {
        return res.status(500).json({ error: 'Erreur envoi MQTT' });
      }

      cache.config = config;
      cache.lastUpdate = new Date();

      res.json({ message: 'Configuration envoyée à l’ESP ✅' });
    }
  );
});

// ===== Lancement serveur =====
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 API disponible sur http://0.0.0.0:${PORT}`);
});
