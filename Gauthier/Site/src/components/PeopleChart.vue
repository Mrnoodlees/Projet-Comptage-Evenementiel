<template>
  <canvas ref="chart"></canvas>
</template>

<script setup>
import { ref, watch } from 'vue'
import { Chart, LineController, LineElement, PointElement, LinearScale, Title, CategoryScale } from 'chart.js'

Chart.register(LineController, LineElement, PointElement, LinearScale, Title, CategoryScale)

const chart = ref(null)
const chartInstance = ref(null)
const dataPoints = ref([])

watch(dataPoints, () => {
  if(chartInstance.value){
    chartInstance.value.data.labels = dataPoints.value.map(d => d.time)
    chartInstance.value.data.datasets[0].data = dataPoints.value.map(d => d.value)
    chartInstance.value.update()
  }
})

// Fonction pour ajouter un point
export function addPoint(value){
  const now = new Date().toLocaleTimeString()
  dataPoints.value.push({ time: now, value })
  if(dataPoints.value.length > 20) dataPoints.value.shift() // garder 20 points max
}

onMounted(() => {
  chartInstance.value = new Chart(chart.value, {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: "Personnes présentes",
        data: [],
        borderColor: "rgb(75, 192, 192)",
        tension: 0.2
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      }
    }
  })
})
</script>
