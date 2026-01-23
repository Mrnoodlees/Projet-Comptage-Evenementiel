<template>
  <!-- LOGIN -->
  <Login v-if="!isAuthenticated" @success="isAuthenticated = true" />

  <!-- ADMIN -->
  <Admin
    v-else-if="isAdmin"
    :maxPeople="maxPeople"
    :battery="battery"
    @update:maxPeople="maxPeople = $event"
    @resetCounters="resetCounters"
    @resetBattery="battery = 100"
    @generatePassage="handleGeneratedPassage"
    @back="isAdmin = false"
  />

  <!-- DASHBOARD -->
  <div v-else class="dashboard">
    <header>
      <h1>Supervision – Comptage</h1>

      <span class="status-battery" :class="statusBatteryClass">
        {{ batteryStatus }}
      </span>

      <span class="status-people" :class="capacityIndicatorClass">
        {{ peopleStatus }}
      </span>

      <button class="admin-btn" @click="isAdmin = true">
        Admin
      </button>
    </header>

    <section class="cards">
      <div class="card highlight">
        <h3>Présents</h3>
        <p>{{ people }}</p>
      </div>

      <div class="card">
        <h3>Entrées</h3>
        <p>{{ entries }}</p>
      </div>

      <div class="card">
        <h3>Sorties</h3>
        <p>{{ exits }}</p>
      </div>

      <div class="card">
        <h3>Batterie</h3>
        <p>{{ battery }}%</p>
      </div>

      <div class="card capacity-card">
        <h3>Capacité max</h3>
        <div class="capacity-container">
          <span class="capacity-indicator" :class="capacityIndicatorClass"></span>
          <span class="capacity-value">{{ maxPeople }}</span>
        </div>
      </div>
    </section>

    <PeopleChart ref="chartRef" />
    <PassageHistory ref="historyRef" />

    <footer>
      MAJ : {{ timestamp }}
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { io } from 'socket.io-client'

import Login from '@/components/Login.vue'
import PeopleChart from '@/components/PeopleChart.vue'
import Admin from '@/components/Admin.vue'
import PassageHistory from '@/components/PassageHistory.vue'

/* ================== AUTH ================== */
const isAuthenticated = ref(false)
const isAdmin = ref(false)

/* ================== DATA ================== */
const people = ref(0)
const entries = ref(0)
const exits = ref(0)
const battery = ref(100)
const maxPeople = ref(100)
const timestamp = ref('-')
const batteryStatus = ref('BATTERIE OK')

/* ================== REFS ================== */
const chartRef = ref(null)
const historyRef = ref(null)
let socket = null

/* ================== API ================== */
const API = 'http://178.32.107.35:3001/api/dashboard'

const loadDashboardState = async () => {
  const res = await fetch(`${API}/state`)
  const data = await res.json()

  people.value = data.people
  entries.value = data.entries
  exits.value = data.exits
  battery.value = data.battery
  maxPeople.value = data.maxPeople
}

const loadHistory = async () => {
  const res = await fetch(`${API}/history`)
  const rows = await res.json()
  rows.forEach(p => historyRef.value?.addEntry(p))
}

const loadChart = async () => {
  const res = await fetch(`${API}/chart`)
  const rows = await res.json()
  rows.forEach(p =>
    chartRef.value?.addValue(p.people, maxPeople.value)
  )
}

/* ================== SOCKET ================== */
onMounted(async () => {
  await loadDashboardState()
  await loadHistory()
  await loadChart()

  socket = io('http://178.32.107.35:3000')

  socket.on('passage', data => handlePassage(data))

  socket.on('status', data => {
    if (data.battery !== undefined) {
      battery.value = data.battery
      batteryStatus.value =
        battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
    }
    timestamp.value = new Date().toLocaleTimeString()
  })

  socket.on('config', data => {
    if (data.maxPeople !== undefined) {
      maxPeople.value = data.maxPeople
    }
  })
})

onBeforeUnmount(() => socket?.disconnect())

/* ================== PASSAGE ================== */
const handlePassage = (data) => {
  if (data.type_passage !== 'FIN') return

  if (data.type === 'ENTREE') {
    entries.value++
    people.value++
  } else if (data.type === 'SORTIE') {
    exits.value++
    people.value = Math.max(0, people.value - 1)
  }

  historyRef.value?.addEntry(data)
  chartRef.value?.addValue(people.value, maxPeople.value)
  timestamp.value = new Date().toLocaleTimeString()
}

/* ================== ADMIN ================== */
const resetCounters = async () => {
  await fetch(`${API}/reset`, { method: 'POST' })

  people.value = 0
  entries.value = 0
  exits.value = 0

  historyRef.value?.resetHistory()
  chartRef.value?.reset()
}

/* ================== COMPUTED ================== */
const statusBatteryClass = computed(() => ({
  ok: batteryStatus.value === 'BATTERIE OK',
  warn: batteryStatus.value === 'BATTERIE FAIBLE'
}))

const capacityIndicatorClass = computed(() => {
  if (people.value >= maxPeople.value) return 'max'
  if (people.value >= maxPeople.value * 0.9) return 'quasi'
  return 'ok'
})

const peopleStatus = computed(() => {
  if (people.value >= maxPeople.value) return 'PLEIN'
  if (people.value >= maxPeople.value * 0.9) return 'QUASI PLEIN'
  return 'LIBRE'
})
</script>

<style src="./src/mainstyle.css"></style>
