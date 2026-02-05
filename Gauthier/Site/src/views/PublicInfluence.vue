<template>
  <div class="dashboard">
    <header>
      <h1>Affluence – Page publique</h1>
    </header>

    <InfluenceChart ref="chartRef" />

    <p v-if="status === 'empty'" class="empty">
      Aucune donnée disponible pour le moment
    </p>

    <p v-else-if="status === 'error'" class="empty">
      Impossible de charger les données
    </p>

    <footer>
      Données mises à jour automatiquement
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import InfluenceChart from '@/components/InfluenceChart.vue'

const chartRef = ref(null)
const status = ref('loading')

const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || window.location.origin
let refreshTimer = null

const toDateString = (value) => new Date(value).toLocaleString()

const buildChart = (rows) => {
  if (!rows.length) {
    status.value = 'empty'
    return
  }

  const labels = rows.map(row => toDateString(row.heure))
  const data = rows.map(row => Number(row.entrees || 0))

  chartRef.value?.render(labels, data)
  status.value = 'ready'
}

const loadInfluence = async () => {
  status.value = 'loading'

  const now = new Date()
  const from = new Date(now.getTime() - 24 * 60 * 60 * 1000)

  const url = new URL(`${API_BASE_URL}/api/public/influence`)
  url.searchParams.set('from', from.toISOString())
  url.searchParams.set('to', now.toISOString())

  try {
    const response = await fetch(url.toString())
    if (!response.ok) {
      status.value = 'error'
      return
    }

    const rows = await response.json()
    buildChart(rows)
  } catch (err) {
    console.warn('API public/influence indisponible', err)
    status.value = 'error'
  }
}

onMounted(() => {
  loadInfluence()
  refreshTimer = setInterval(loadInfluence, 60 * 1000)
})

onBeforeUnmount(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
})
</script>

<style scoped>
.empty {
  color: #94a3b8;
  font-size: 14px;
  text-align: center;
  margin-top: 8px;
}
</style>
