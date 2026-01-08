<template>
  <div class="app">
    <h1>Supervision Comptage Événementiel</h1>

    <div class="grid">
      <div class="card">
        <h2>Personnes présentes</h2>
        <p>{{ data.currentPeople }}</p>
      </div>

      <div class="card">
        <h2>Entrées</h2>
        <p>{{ data.entries }}</p>
      </div>

      <div class="card">
        <h2>Sorties</h2>
        <p>{{ data.exits }}</p>
      </div>

      <div class="card">
        <h2>Batterie</h2>
        <p>{{ data.battery }}%</p>
      </div>

      <div class="card">
        <h2>État système</h2>
        <p :class="statusClass">{{ data.status }}</p>
      </div>
    </div>

    <h2>Graphique des personnes présentes</h2>
    <canvas ref="chart"></canvas>

    <small>Dernière mise à jour : {{ data.timestamp }}</small>
  </div>
</template>

<script setup>
import { reactive, onMounted, onUnmounted, computed, ref } from 'vue'
import { Chart, LineController, LineElement, PointElement, LinearScale, Title, CategoryScale } from 'chart.js'

// --- CONFIG CHART.JS ---
Chart.register(LineController, LineElement, PointElement, LinearScale, Title, CategoryScale)
const chart = ref(null)
let chartInstance = null
const dataPoints = reactive([]) // stocke les derniers points pour le graphique

function addPoint(value) {
  const now = new Date().toLocaleTimeString()
  dataPoints.push({ time: now, value })
  if (dataPoints.length > 20) dataPoints.shift() // garder max 20 points
  if (chartInstance) {
    chartInstance.data.labels = dataPoints.map(d => d.time)
    chartInstance.data.datasets[0].data = dataPoints.map(d => d.value)
    chartInstance.update()
  }
}

// --- DATA ET STATUTS ---
let socket = null
const data = reactive({
  currentPeople: 0,
  entries: 0,
  exits: 0,
  battery: 0,
  status: 'DÉCONNECTÉ',
  timestamp: '-'
})

const translateStatus = (status) => {
  switch (status) {
    case 'CONNECTED': return 'CONNECTÉ'
    case 'DISCONNECTED': return 'DÉCONNECTÉ'
    case 'RECONNECTING': return 'RECONNEXION'
    case 'WARN': return 'ATTENTION'
    case 'ERROR': return 'ERREUR'
    default: return 'OK'
  }
}

const connectWebsocket = () => {
  socket = new WebSocket('ws://TON_SERVEUR:PORT/ws')

  socket.onopen = () => { data.status = 'CONNECTÉ' }

  socket.onmessage = (event) => {
    try {
      const msg = JSON.parse(event.data)

      data.currentPeople = msg.currentPeople
      data.entries = msg.entries
      data.exits = msg.exits
      data.battery = msg.battery
      data.timestamp = msg.timestamp
      data.status = translateStatus(msg.status || 'OK')

      addPoint(msg.currentPeople) // mise à jour du graphique

    } catch (e) {
      console.error('Bad JSON', e)
    }
  }

  socket.onclose = () => {
    data.status = 'RECONNEXION'
    setTimeout(connectWebsocket, 2000)
  }
}

onMounted(() => {
  connectWebsocket()

  // Init graphique
  chartInstance = new Chart(chart.value, {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: "Personnes présentes",
        data: [],
        borderColor: "rgb(75, 192, 192)",
        backgroundColor: "rgba(75, 192, 192, 0.2)",
        tension: 0.2
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      }
    }
  })
})

onUnmounted(() => { if (socket) socket.close() })

const statusClass = computed(() => ({
  ok: data.status === 'OK' || data.status === 'CONNECTÉ',
  warn: data.status === 'ATTENTION',
  error: data.status === 'ERREUR' || data.status === 'DÉCONNECTÉ'
}))
</script>

<style>
.app {
  font-family: Arial, sans-serif;
  padding: 30px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.card {
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 10px;
  background: #fafafa;
  text-align: center;
}

.ok { color: green; }
.warn { color: orange; }
.error { color: red; }

canvas {
  margin-top: 20px;
  max-width: 100%;
}
</style>
