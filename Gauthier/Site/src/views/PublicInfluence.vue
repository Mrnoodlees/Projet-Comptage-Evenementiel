<template>
  <div class="dashboard">
    <header>
      <h1>Affluence – Page publique</h1>
    </header>

    <InfluenceChart ref="chartRef" />

    <p v-if="status === 'empty'" class="empty">
      Aucune donnée disponible pour le moment
    </p>

    <p v-else-if="status === 'error'" class="empty">
      Impossible de charger les données
    </p>

    <footer>
      Données mises à jour automatiquement
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import InfluenceChart from '@/components/InfluenceChart.vue'

// Chart reference for rendering.
const chartRef = ref(null)
// UI status: loading, ready, empty, error.
const status = ref('loading')
// Access granted only via QR token.
const isAllowed = ref(false)

// URL de l’API à appeler depuis la page publique.
// En production VPS, elle peut pointer vers Apache qui proxifie ensuite vers l’API.
const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || window.location.origin
let refreshTimer = null
const route = useRoute()
const router = useRouter()
const PUBLIC_ACCESS_KEY = 'public_access_v1'

const verifyPublicToken = async (token) => {
  // Valide le token public avant d’afficher l’analyse d’affluence.
  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/public-verify?token=${encodeURIComponent(token)}`)
    if (!response.ok) return false
    const payload = await response.json()
    return Boolean(payload?.ok)
  } catch {
    return false
  }
}

const toHourLabel = (value) =>
  new Date(value).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })

// Build hourly cumulative series from API rows.
const buildHourlySeries = (rows, from, to, base = 0) => {
  // Reconstitue une valeur cumulative par heure :
  // présents = base + entrées - sorties.
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

const buildChart = (rows, from, to, base) => {
  // Transforme la réponse API en données utilisables par Chart.js.
  if (!rows.length) {
    status.value = 'empty'
    return
  }

  const { labels, data } = buildHourlySeries(rows, from, to, base)

  chartRef.value?.render(labels, data)
  status.value = 'ready'
}

// Fetch and render public influence data.
const loadInfluence = async () => {
  // La page publique affiche par défaut les 24 dernières heures.
  if (!isAllowed.value) return
  status.value = 'loading'

  const now = new Date()
  const from = new Date(now.getTime() - 24 * 60 * 60 * 1000)

  const url = new URL(`${API_BASE_URL}/api/public/influence`)
  url.searchParams.set('from', from.toISOString())
  url.searchParams.set('to', now.toISOString())
  url.searchParams.set('include_base', '1')

  try {
    const response = await fetch(url.toString())
    if (!response.ok) {
      status.value = 'error'
      return
    }

    const payload = await response.json()
    const rows = payload.rows || []
    const base = Number(payload.base || 0)
    buildChart(rows, from, now, base)
  } catch (err) {
    console.warn('API public/influence indisponible', err)
    status.value = 'error'
  }
}

onMounted(() => {
  // Si le QR a déjà été validé dans l’onglet, on évite de redemander le token.
  const alreadyAllowed = sessionStorage.getItem(PUBLIC_ACCESS_KEY) === '1'
  if (alreadyAllowed) {
    isAllowed.value = true
    loadInfluence()
    refreshTimer = setInterval(loadInfluence, 5 * 1000)
    return
  }

  const token = route.query.public_token
  if (typeof token !== 'string') {
    // Sans token, on renvoie vers le dashboard classique.
    router.replace('/dashboard')
    return
  }

  verifyPublicToken(token).then(ok => {
    // Après validation, la courbe se rafraîchit automatiquement.
    if (!ok) {
      router.replace('/dashboard')
      return
    }

    sessionStorage.setItem(PUBLIC_ACCESS_KEY, '1')
    isAllowed.value = true
    loadInfluence()
    refreshTimer = setInterval(loadInfluence, 5 * 1000)
  })
})

onBeforeUnmount(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
})
</script>

<style scoped>
.empty {
  color: #94a3b8;
  font-size: 14px;
  text-align: center;
  margin-top: 8px;
}
</style>
