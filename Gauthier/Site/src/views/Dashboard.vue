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
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { io } from 'socket.io-client'

import Login from '@/components/Login.vue'
import PeopleChart from '@/components/PeopleChart.vue'
import Admin from '@/components/Admin.vue'
import PassageHistory from '@/components/PassageHistory.vue'

/* ================== CONSTANTES ================== */
const STORAGE_COUNTERS = 'supervision_counters_v1'
const STORAGE_CHART = 'supervision_chart_v1'
const STORAGE_HISTORY = 'passage_history_v1'
const SOCKET_URL = import.meta.env.VITE_SOCKET_URL || 'http://178.32.107.35:3000'
const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || SOCKET_URL.replace(':3000', ':3001')

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

/* ================== ANTI DOUBLE PAR PORTE ================== */
const lastPassageByDoor = {}

/* ================== PERSISTENCE ================== */
const loadCounters = () => {
  const saved = localStorage.getItem(STORAGE_COUNTERS)
  if (saved) {
    const data = JSON.parse(saved)
    people.value = data.people ?? 0
    entries.value = data.entries ?? 0
    exits.value = data.exits ?? 0
  }
}

const saveCounters = () => {
  localStorage.setItem(
    STORAGE_COUNTERS,
    JSON.stringify({ people: people.value, entries: entries.value, exits: exits.value })
  )
}

const loadChart = () => {
  const saved = localStorage.getItem(STORAGE_CHART)
  if (saved && chartRef.value) {
    const data = JSON.parse(saved)
    data.forEach(d => chartRef.value.addValue(d.people, d.maxPeople))
  }
}

const saveChart = () => {
  if (!chartRef.value) return
  const values = chartRef.value.getValues()
  localStorage.setItem(STORAGE_CHART, JSON.stringify(values))
}

/* ================== API ================== */
const fetchJson = async (path, options = {}) => {
  const response = await fetch(`${API_BASE_URL}${path}`, options)
  if (!response.ok) {
    throw new Error(`API ${response.status}`)
  }
  return response.json()
}

const hydrateFromApi = async () => {
  try {
    const state = await fetchJson('/api/dashboard/state')
    if (state) {
      if (state.people !== undefined) people.value = Number(state.people)
      if (state.entries !== undefined) entries.value = Number(state.entries)
      if (state.exits !== undefined) exits.value = Number(state.exits)
      if (state.battery !== undefined) {
        battery.value = Number(state.battery)
        batteryStatus.value =
          battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
      }
      if (state.maxPeople !== undefined) maxPeople.value = Number(state.maxPeople)
      saveCounters()
      timestamp.value = new Date().toLocaleTimeString()
    }
  } catch (err) {
    console.warn('API dashboard/state indisponible', err)
  }

  if (!localStorage.getItem(STORAGE_CHART) && chartRef.value) {
    try {
      const rows = await fetchJson('/api/dashboard/people-chart')
      rows.forEach(row => {
        const peopleValue = Number(row.people)
        if (!Number.isFinite(peopleValue)) return
        chartRef.value.addValue(peopleValue, maxPeople.value)
      })
      saveChart()
    } catch (err) {
      console.warn('API dashboard/people-chart indisponible', err)
    }
  }

  if (!localStorage.getItem(STORAGE_HISTORY) && historyRef.value) {
    try {
      const rows = await fetchJson('/api/passage?limit=100')
      const ordered = [...rows].reverse()
      ordered.forEach(row => {
        const dateValue = row.date_heure || row.ts
        const typeValue = row.type || row.mode_passage
        const appareilValue = row.appareil_id || row.capteur_id || row.capteur || '-'
        if (!dateValue || !typeValue) return
        historyRef.value.addEntry({
          date_heure: dateValue,
          type: typeValue,
          appareil_id: appareilValue
        })
      })
    } catch (err) {
      console.warn('API passage indisponible', err)
    }
  }
}

/* ================== SOCKET ================== */
onMounted(async () => {
  loadCounters()
  await nextTick()
  loadChart()
  await hydrateFromApi()

  socket = io(SOCKET_URL)

  socket.on('connect', () => console.log('✅ Socket connecté'))

  socket.on('init', data => {
    maxPeople.value = data.maxPeople ?? maxPeople.value
    battery.value = data.bat ?? battery.value
  })

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
    if (data.maxPeople !== undefined) maxPeople.value = data.maxPeople
  })
})

onBeforeUnmount(() => socket?.disconnect())

/* ================== PASSAGE HANDLER ================== */
const handlePassage = (data) => {
  if (data.type_passage !== 'FIN') return

  const now = Date.now()
  const doorId = data.appareil_id
  if (!lastPassageByDoor[doorId]) lastPassageByDoor[doorId] = 0
  if (now - lastPassageByDoor[doorId] < 300) return
  lastPassageByDoor[doorId] = now

  if (data.type === 'ENTREE') {
    entries.value++
    people.value++
  } else if (data.type === 'SORTIE') {
    exits.value++
    people.value = Math.max(0, people.value - 1)
  }

  saveCounters()
  historyRef.value?.addEntry(data)
  chartRef.value?.addValue(people.value, maxPeople.value)
  saveChart()
  timestamp.value = new Date().toLocaleTimeString()
}

/* ================== ADMIN ACTIONS ================== */
const resetCounters = () => {
  people.value = 0
  entries.value = 0
  exits.value = 0
  localStorage.removeItem(STORAGE_COUNTERS)
  localStorage.removeItem(STORAGE_CHART)
  historyRef.value?.resetHistory()
  chartRef.value?.reset()
}

/* ================== GENERATEUR ADMIN ================== */
const handleGeneratedPassage = (dataArray) => {
  dataArray.forEach((data, index) => {
    setTimeout(() => {
      handlePassage({
        ...data,
        date_heure: new Date(Date.now() + index * 10).toISOString()
      })
    }, index * 50)
  })
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
