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
          <span
            class="capacity-indicator"
            :class="capacityIndicatorClass"
          ></span>
          <span class="capacity-value">
            {{ maxPeople }}
          </span>
        </div>
      </div>
    </section>

    <PeopleChart ref="chartRef" />

    <footer>
      MAJ : {{ timestamp }}
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { io } from 'socket.io-client'
import Login from './components/Login.vue'
import PeopleChart from './components/PeopleChart.vue'
import Admin from './components/Admin.vue'

/* --- AUTH & NAV --- */
const isAuthenticated = ref(false)
const isAdmin = ref(false)

/* --- DATA --- */
const people = ref(0)
const entries = ref(0)
const exits = ref(0)
const battery = ref(100)
const maxPeople = ref(100)
const timestamp = ref('-')

// Status
const batteryStatus = ref('BATTERIE OK')

const chartRef = ref(null)
let socket = null

/* --- ANTI DOUBLE COMPTE PAR PORTE --- */
const lastPassageByDoor = {}

/* --- SOCKET.IO --- */
onMounted(() => {
  socket = io('http://178.32.107.35:3000')

  socket.on('connect', () => {
    console.log('✅ Socket connecté')
  })

  socket.on('init', data => {
    console.log('INIT', data)
    people.value = data.people ?? people.value
    entries.value = data.entries ?? entries.value
    exits.value = data.exits ?? exits.value
    battery.value = data.bat ?? battery.value
    maxPeople.value = data.maxPeople ?? maxPeople.value
  })

  socket.on('passage', data => {
    console.log('PASSAGE', data)

    // On compte UNIQUEMENT les passages validés
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

    chartRef.value?.addValue(people.value, maxPeople.value)
    timestamp.value = new Date().toLocaleTimeString()
  })

  socket.on('status', data => {
    console.log('STATUS', data)

    if (data.battery !== undefined) {
      battery.value = data.battery
      batteryStatus.value =
        battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
    }

    timestamp.value = new Date().toLocaleTimeString()
  })

  socket.on('config', data => {
    console.log('CONFIG', data)
    if (data.maxPeople !== undefined) {
      maxPeople.value = data.maxPeople
    }
  })
})

onBeforeUnmount(() => {
  socket?.disconnect()
})

/* --- ADMIN ACTIONS --- */
const resetCounters = () => {
  people.value = 0
  entries.value = 0
  exits.value = 0
}

/* --- COMPUTED --- */
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
