<template>
  <div class="dashboard">
    <header>
      <h1>Supervision – Comptage</h1>
      <span class="status-battery" :class="statusBatteryClass">{{ batteryStatus }}</span>
      <span class="status-people" :class="capacityIndicatorClass">{{ peopleStatus }}</span>
        <button class="admin-btn" @click="goToAdmin">Admin</button>
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

      <!-- Carte capacité max -->
      <div class="card capacity-card">
        <h3>Capacité max</h3>
        <div class="capacity-container">
          <span class="capacity-indicator" :class="capacityIndicatorClass"></span>
          <input type="number" v-model.number="maxPeople" min="1" class="transparent-input" />
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
import { ref, computed, onMounted } from 'vue'
import PeopleChart from './components/PeopleChart.vue'

const people = ref(0)
const entries = ref(0)
const exits = ref(0)
const battery = ref(100)
const maxPeople = ref(100)
const timestamp = ref('-')

// Status
const batteryStatus = ref('BATTERIE OK')

const chartRef = ref(null)

onMounted(() => {
  setInterval(() => {
    const inCount = Math.floor(Math.random() * 5)
    const outCount = Math.floor(Math.random() * 4)

    entries.value += inCount
    exits.value += outCount
    people.value = Math.max(0, entries.value - exits.value)

    battery.value = Math.max(0, battery.value - 1)

    // Statut batterie
    if (battery.value < 30) batteryStatus.value = 'BATTERIE FAIBLE'
    else batteryStatus.value = 'BATTERIE OK'

    chartRef.value.addValue(people.value, maxPeople.value)
    timestamp.value = new Date().toLocaleTimeString()
  }, 1000)
})

// Classes pour le badge batterie
const statusBatteryClass = computed(() => ({
  ok: batteryStatus.value === 'BATTERIE OK',
  warn: batteryStatus.value === 'BATTERIE FAIBLE'
}))

// Couleur de l’indicateur capacité max
const capacityIndicatorClass = computed(() => {
  if (people.value >= maxPeople.value) return 'max'
  if (people.value >= maxPeople.value * 0.9) return 'quasi'
  return 'ok'
})

// Texte à afficher pour les personnes
const peopleStatus = computed(() => {
  if (people.value >= maxPeople.value) return 'PLEIN'
  if (people.value >= maxPeople.value * 0.9) return 'QUASI PLEIN'
  return 'LIBRE'
})
</script>

<style>
body {
  margin: 0;
  background: #0f172a;
}

.dashboard {
  color: #e5e7eb;
  font-family: system-ui, Arial, sans-serif;
  padding: 16px;
  max-width: 1200px;
  margin: auto;
}

header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}

header h1 {
  font-size: 1.1rem;
}

/* Badge batterie */
.status-battery {
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 0.75rem;
}
.status-battery.ok { background: #16a34a; }
.status-battery.warn { background: #dc2626; }

/* Badge personnes */
.status-people {
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 0.75rem;
  min-width: 80px;
  text-align: center;
}
.status-people.ok { background: #2563eb; }
.status-people.quasi { background: #facc15; color: #0f172a; }
.status-people.max { background: #dc2626; }

/* Cartes */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
  gap: 12px;
  margin-bottom: 14px;
}

.card {
  background: #1e293b;
  padding: 12px;
  border-radius: 12px;
  text-align: center;
}

.card.highlight {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
}

.card h3 {
  font-size: 0.8rem;
  margin-bottom: 4px;
}

.card p {
  font-size: 1.4rem;
  font-weight: 600;
}

/* Carte capacité max */
.capacity-card .capacity-container {
  display: flex;
  align-items: center;
  gap: 6px;
}

/* Indicateur capacité */
.capacity-indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  display: inline-block;
}
.capacity-indicator.ok { background: #2563eb; }
.capacity-indicator.quasi { background: #facc15; }
.capacity-indicator.max { background: #dc2626; }
.admin-btn {
  margin-left: auto;
  padding: 6px 12px;
  border-radius: 10px;
  border: none;
  background: #334155;
  color: #e5e7eb;
  font-size: 0.75rem;
  cursor: pointer;
  transition: background 0.2s;
}

.admin-btn:hover {
  background: #475569;
}

/* Input transparent */
.transparent-input {
  width: 100%;
  box-sizing: border-box;
  padding: 4px 8px;
  border-radius: 8px;
  border: none;
  background: #1e293b;
  color: #e5e7eb;
  text-align: center;
  font-weight: 600;
}

footer {
  margin-top: 10px;
  font-size: 0.7rem;
  opacity: 0.7;
  text-align: right;
}
</style>
