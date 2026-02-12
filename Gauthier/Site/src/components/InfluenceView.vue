<template>
  <div class="cards">
    <InfluenceFilter @apply="generate" />
    <InfluenceChart ref="chartRef" />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import InfluenceFilter from './InfluenceFilter.vue'
import InfluenceChart from './InfluenceChart.vue'

const chartRef = ref(null)
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || window.location.origin

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

const generate = async ({ from, to }) => {
  const url = new URL(`${API_BASE_URL}/api/public/influence`)
  url.searchParams.set('from', from.toISOString())
  url.searchParams.set('to', to.toISOString())
  url.searchParams.set('include_base', '1')

  try {
    const response = await fetch(url.toString())
    if (!response.ok) return

    const payload = await response.json()
    const rows = payload.rows || []
    const base = Number(payload.base || 0)
    const { labels, data } = buildHourlySeries(rows, from, to, base)
    chartRef.value?.render(labels, data)
  } catch {
    // Silence: l'UI reste inchangée si l'API est indisponible
  }
}
</script>
