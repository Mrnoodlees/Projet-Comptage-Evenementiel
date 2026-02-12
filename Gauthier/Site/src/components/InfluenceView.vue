<template>
  <div class="cards">
    <InfluenceFilter @apply="generate" />

    <div class="card export-card">
      <h3>Export</h3>
      <p class="export-hint">Télécharger la courbe d’influence</p>

      <div class="export-actions">
        <button class="admin-btn" :disabled="!canExport" @click="exportPng">
          Export PNG
        </button>
        <button class="admin-btn" :disabled="!canExport" @click="exportCsv">
          Export CSV
        </button>
      </div>
    </div>

    <InfluenceChart ref="chartRef" />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import InfluenceFilter from './InfluenceFilter.vue'
import InfluenceChart from './InfluenceChart.vue'

const chartRef = ref(null)
const lastDataset = ref({ labels: [], data: [] })
const lastRange = ref(null)
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || window.location.origin

const canExport = computed(() => (lastDataset.value.labels || []).length > 0)

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
    lastDataset.value = { labels, data }
    lastRange.value = { from, to }
  } catch {
    // Silence: l'UI reste inchangée si l'API est indisponible
  }
}

const formatStamp = (date) => {
  const pad = (value) => String(value).padStart(2, '0')
  return [
    date.getFullYear(),
    pad(date.getMonth() + 1),
    pad(date.getDate())
  ].join('-') + '_' + [pad(date.getHours()), pad(date.getMinutes())].join('-')
}

const buildFileName = (extension) => {
  if (lastRange.value?.from && lastRange.value?.to) {
    return `influence_${formatStamp(lastRange.value.from)}_${formatStamp(lastRange.value.to)}.${extension}`
  }
  return `influence_${formatStamp(new Date())}.${extension}`
}

const exportPng = () => {
  const dataUrl = chartRef.value?.toImageDataUrl?.()
  if (!dataUrl) return
  const link = document.createElement('a')
  link.href = dataUrl
  link.download = buildFileName('png')
  document.body.appendChild(link)
  link.click()
  link.remove()
}

const exportCsv = () => {
  const { labels = [], data = [] } = lastDataset.value || {}
  if (!labels.length) return

  const lines = ['heure,personnes']
  labels.forEach((label, index) => {
    const value = data[index]
    lines.push(`${label},${value ?? ''}`)
  })

  const blob = new Blob([lines.join('\n')], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = buildFileName('csv')
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}
</script>

<style scoped>
.export-card {
  text-align: left;
}

.export-hint {
  color: #94a3b8;
  font-size: 0.8rem;
  margin: 6px 0 12px;
}

.export-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.export-actions .admin-btn {
  margin-left: 0;
}
</style>
