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

const whiteBackgroundPlugin = {
  id: 'whiteBackground',
  beforeDraw: (chart, _args, options) => {
    if (!options?.enabled) return
    const { ctx, width, height } = chart
    ctx.save()
    ctx.globalCompositeOperation = 'destination-over'
    ctx.fillStyle = options?.color || '#ffffff'
    ctx.fillRect(0, 0, width, height)
    ctx.restore()
  }
}

const render = (labels, data, options = {}) => {
  lastLabels = labels
  lastData = data

  chart?.destroy()

  chart = new Chart(canvas.value, {
    type: 'line',
    plugins: [whiteBackgroundPlugin],
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
      plugins: {
        legend: { display: false },
        whiteBackground: { enabled: false }
      },
      scales: {
        x: {
          ticks: {
            color: '#cbd5e1',
            autoSkip: true,
            maxTicksLimit: 12,
            maxRotation: 45,
            minRotation: 0
          },
          grid: { drawBorder: false, color: 'rgba(255,255,255,0.08)' },
          title: { display: false }
        },
        y: {
          beginAtZero: true,
          ticks: { stepSize: 1, precision: 0, color: '#cbd5e1' },
          grid: { drawBorder: false, color: 'rgba(255,255,255,0.08)' },
          title: { display: false }
        }
      }
    }
  })
}

const toImageDataUrl = () => {
  if (!chart) return null

  const original = {
    xTicks: chart.options.scales?.x?.ticks?.color,
    yTicks: chart.options.scales?.y?.ticks?.color,
    xGrid: chart.options.scales?.x?.grid?.color,
    yGrid: chart.options.scales?.y?.grid?.color,
    xTitle: chart.options.scales?.x?.title,
    yTitle: chart.options.scales?.y?.title,
    whiteBackground: chart.options.plugins?.whiteBackground
  }

  chart.options.scales.x.ticks.color = '#111827'
  chart.options.scales.y.ticks.color = '#111827'
  chart.options.scales.x.grid.color = 'rgba(0,0,0,0.1)'
  chart.options.scales.y.grid.color = 'rgba(0,0,0,0.1)'
  chart.options.scales.x.title = {
    display: true,
    text: 'Heure',
    color: '#111827',
    font: { weight: '600' }
  }
  chart.options.scales.y.title = {
    display: true,
    text: 'Personnes',
    color: '#111827',
    font: { weight: '600' }
  }
  chart.options.plugins.whiteBackground = { enabled: true, color: '#ffffff' }

  chart.update('none')
  const url = chart.toBase64Image()

  chart.options.scales.x.ticks.color = original.xTicks
  chart.options.scales.y.ticks.color = original.yTicks
  chart.options.scales.x.grid.color = original.xGrid
  chart.options.scales.y.grid.color = original.yGrid
  chart.options.scales.x.title = original.xTitle
  chart.options.scales.y.title = original.yTitle
  chart.options.plugins.whiteBackground = original.whiteBackground
  chart.update('none')

  return url
}
const getDataset = () => ({ labels: lastLabels, data: lastData })

defineExpose({ render, toImageDataUrl, getDataset })

onUnmounted(() => chart?.destroy())
</script>

<style scoped>
.chart-container {
  height: 280px;
}
</style>
