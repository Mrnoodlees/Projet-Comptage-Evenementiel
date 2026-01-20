<template>
  <div class="dashboard">
    <header>
      <h1>Affluence – Page publique</h1>
    </header>

    <InfluenceChart :data="hourlyData" />

    <footer>
      Données mises à jour automatiquement
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import InfluenceChart from '@/components/InfluenceChart.vue'

const STORAGE_HISTORY = 'supervision_history_v1'

/* ================== LOAD HISTORY ================== */
const history = JSON.parse(localStorage.getItem(STORAGE_HISTORY) || '[]')

/* ================== AGGREGATION ================== */
const hourlyData = computed(() => {
  const map = {}

  history.forEach(p => {
    if (p.type !== 'ENTREE') return

    const date = new Date(p.date_heure)
    const hour = `${date.getHours().toString().padStart(2, '0')}:00`

    map[hour] = (map[hour] || 0) + 1
  })

  return Object.keys(map)
    .sort()
    .map(hour => ({ hour, count: map[hour] }))
})
</script>
