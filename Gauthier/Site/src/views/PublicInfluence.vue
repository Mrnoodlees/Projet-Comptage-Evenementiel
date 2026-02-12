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

const toHourLabel = (value) =>
  new Date(value).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })

const buildHourlySeries = (rows, from, to, base = 0) => {
  const map = new Map(rows.map(row => [new Date(row.heure).getTime(), row]))
  const labels = []
  const data = []

  const cursor = new Date(from)
  cursor.setMinutes(0, 0, 0)
  const end = new Date(to)
  end.setMinutes(0, 0, 0)

  let people = Number(base || 0)
  while (cursor <= end) {
    const key = cursor.getTime()
    const row = map.get(key)
    labels.push(toHourLabel(cursor))
    const entrees = Number(row?.entrees || 0)
    const sorties = Number(row?.sorties || 0)
    people += entrees - sorties
    if (people < 0) people = 0
    data.push(people)
    cursor.setHours(cursor.getHours() + 1)
  }

  return { labels, data }
}

const buildChart = (rows, from, to, base) => {
  if (!rows.length) {
    status.value = 'empty'
    return
  }

  const { labels, data } = buildHourlySeries(rows, from, to, base)

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
  url.searchParams.set('include_base', '1')

  try {
    const response = await fetch(url.toString())
    if (!response.ok) {
      status.value = 'error'
      return
    }

    const payload = await response.json()
    const rows = payload.rows || []
    const base = Number(payload.base || 0)
    buildChart(rows, from, now, base)
  } catch (err) {
    console.warn('API public/influence indisponible', err)
    status.value = 'error'
  }
}

onMounted(() => {
  loadInfluence()
  refreshTimer = setInterval(loadInfluence, 5 * 1000)
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
