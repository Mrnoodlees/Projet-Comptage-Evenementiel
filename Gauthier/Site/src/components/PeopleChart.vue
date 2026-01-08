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
let index = 0
const MAX_DISPLAYED_POINTS = 25
let yMax = 50

const addValue = (value, maxLimit) => {
  if (!chart) return

  chart.data.labels.push(index)
  chart.data.datasets[0].data.push(value)
  index++

  // Scroll fluide : défilement via min/max
  if (chart.data.labels.length > MAX_DISPLAYED_POINTS) {
    chart.options.scales.x.min = index - MAX_DISPLAYED_POINTS
    chart.options.scales.x.max = index - 1
  }

  // Axe Y dynamique mais stable
  const maxValue = Math.max(...chart.data.datasets[0].data, maxLimit)
  yMax = Math.max(yMax, maxValue)
  chart.options.scales.y.max = Math.ceil(yMax / 10) * 10 + 10

  chart.update('none') // update rapide sans animation
}

defineExpose({ addValue })

onMounted(() => {
  chart = new Chart(canvas.value, {
    type: 'line',
    data: {
      labels: [],
      datasets: [
        {
          label: 'Personnes présentes',
          data: [],
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59,130,246,0.2)',
          borderWidth: 2.5,
          tension: 0.6,
          cubicInterpolationMode: 'monotone',
          pointRadius: 0,
          fill: true
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      animation: { duration: 500, easing: 'easeOutQuart' },
      plugins: { legend: { display: false } },
      layout: { padding: { top: 10, bottom: 5 } },
      scales: {
        x: {
          type: 'linear',
          display: false,
          min: 0,
          max: MAX_DISPLAYED_POINTS
        },
        y: {
          beginAtZero: true,
          min: 0,
          ticks: { stepSize: 10, precision: 0 },
          grid: { drawBorder: false, color: 'rgba(255,255,255,0.08)' }
        }
      }
    }
  })
})

onUnmounted(() => {
  chart?.destroy()
})
</script>

<style scoped>
.chart-container {
  height: 220px;
}

@media (max-width: 600px) {
  .chart-container {
    height: 180px;
  }
}
</style>
