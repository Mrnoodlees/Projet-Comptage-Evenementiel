<template>
  <div class="cards">
    <InfluenceFilter @apply="generate" />
    <InfluenceChart ref="chartRef" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import InfluenceFilter from './InfluenceFilter.vue'
import InfluenceChart from './InfluenceChart.vue'

const chartRef = ref(null)
const passages = ref([])

/* =========================
   1️⃣ WebSocket
========================= */
onMounted(() => {
  const ws = new WebSocket('ws://TON_SERVEUR')

  ws.onmessage = (event) => {
    const data = JSON.parse(event.data)

    // on stocke les passages reçus
    passages.value.push(data)
  }
})

/* =========================
   2️⃣ Génération du graphe
========================= */
const generate = ({ from, to }) => {
  // filtrage par dates
  const filtered = passages.value.filter(p => {
    const d = new Date(p.date_heure)
    return d >= from && d <= to
  })

  /* =========================
     3️⃣ Agrégation par heure
  ========================= */
  const buckets = {}

  filtered.forEach(p => {
    const d = new Date(p.date_heure)

    // on regroupe par heure
    d.setMinutes(0, 0, 0)
    const key = d.toISOString()

    if (!buckets[key]) buckets[key] = 0
    buckets[key]++
  })

  /* =========================
     4️⃣ Données pour le graphe
  ========================= */
  const labels = Object.keys(buckets).sort()
  const data = labels.map(l => buckets[l])

  /* =========================
     5️⃣ Affichage
  ========================= */
  chartRef.value.render(
    labels.map(l => new Date(l).toLocaleString()),
    data
  )
}
</script>