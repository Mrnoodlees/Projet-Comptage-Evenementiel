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

const render = (labels, data) => {
  chart?.destroy()

  chart = new Chart(canvas.value, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: 'Passages / heure',
        data,
        backgroundColor: '#2563eb'
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true }
      }
    }
  })
}

defineExpose({ render })

onUnmounted(() => chart?.destroy())
</script>

<style scoped>
.chart-container {
  height: 280px;
}
</style>
