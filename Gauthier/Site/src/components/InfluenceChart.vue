<template>
  <div class="chart-container">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import Chart from 'chart.js/auto'

const canvas = ref(null)
let chart = null
let lastLabels = []
let lastData = []

const render = (labels, data) => {
  lastLabels = labels
  lastData = data

  chart?.destroy()

  chart = new Chart(canvas.value, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label: 'Personnes présentes',
        data,
        borderColor: '#3b82f6',
        backgroundColor: 'rgba(59,130,246,0.2)',
        borderWidth: 2.5,
        tension: 0.4,
        pointRadius: 0,
        fill: true
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        x: {
          ticks: { color: '#cbd5e1' },
          grid: { drawBorder: false, color: 'rgba(255,255,255,0.08)' }
        },
        y: {
          beginAtZero: true,
          ticks: { stepSize: 1, precision: 0, color: '#cbd5e1' },
          grid: { drawBorder: false, color: 'rgba(255,255,255,0.08)' }
        }
      }
    }
  })
}

const toImageDataUrl = () => chart?.toBase64Image?.() || null
const getDataset = () => ({ labels: lastLabels, data: lastData })

defineExpose({ render, toImageDataUrl, getDataset })

onUnmounted(() => chart?.destroy())
</script>

<style scoped>
.chart-container {
  height: 280px;
}
</style>
