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

const STORAGE_KEY = 'influence_graphs_v1'
const chartRef = ref(null)

/* 🔁 Récupération de l’historique */
const getHistory = () => {
  return JSON.parse(localStorage.getItem('passage_history_v1') || '[]')
}

const generate = ({ from, to }) => {
  const history = getHistory()

  const filtered = history.filter(p => {
    const d = new Date(p.date_heure)
    return d >= from && d <= to
  })

  const buckets = {}

  filtered.forEach(p => {
    const d = new Date(p.date_heure)
    d.setMinutes(0, 0, 0)
    const key = d.toISOString()

    if (!buckets[key]) buckets[key] = 0
    buckets[key]++
  })

  const labels = Object.keys(buckets).sort()
  const data = labels.map(l => buckets[l])

  chartRef.value.render(
    labels.map(l => new Date(l).toLocaleString()),
    data
  )

  saveGraph({ from, to, labels, data })
}

const saveGraph = (graph) => {
  const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]')
  saved.push({ date: new Date(), ...graph })
  localStorage.setItem(STORAGE_KEY, JSON.stringify(saved))
}
</script>
