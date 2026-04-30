<template>
  <!-- QR ONLY (public mode) -->
  <QrOnly v-if="PUBLIC_MODE && !accessViaQr && !isCheckingAccess" />

  <!-- LOGIN -->
  <!-- En mode privé, l’utilisateur doit se connecter avant de voir le dashboard. -->
  <Login
    v-else-if="!PUBLIC_MODE && !isAuthenticated && !isCheckingAccess"
    @success="handleLoginSuccess"
  />

  <!-- ADMIN -->
  <!-- Le panneau admin est volontairement désactivé en mode public/VPS. -->
  <Admin
    v-else-if="isAdmin && !PUBLIC_MODE"
    :maxPeople="maxPeople"
    :battery="battery"
    @update:maxPeople="updateMaxPeople"
    @resetCounters="resetCounters"
    @resetBattery="battery = 100"
    @generatePassage="handleGeneratedPassage"
    @back="isAdmin = false"
  />

  <!-- DASHBOARD -->
  <!-- Vue de supervision : elle sert à la fois au dashboard privé et au QR public. -->
  <div v-else class="dashboard">
    <header>
      <h1>Supervision – Comptage</h1>

      <span v-if="!accessViaQr" class="status-battery" :class="statusBatteryClass">
        {{ batteryStatus }}
      </span>

      <span class="status-people" :class="capacityIndicatorClass">
        {{ peopleStatus }}
      </span>

      <button v-if="!accessViaQr && !PUBLIC_MODE" class="admin-btn" @click="isAdmin = true">
        Admin
      </button>
    </header>

    <section class="cards">
      <div class="card highlight">
        <h3>Présents</h3>
        <p>{{ people }}</p>
      </div>

      <div class="card">
        <h3>Entrées</h3>
        <p>{{ entries }}</p>
      </div>

      <div class="card">
        <h3>Sorties</h3>
        <p>{{ exits }}</p>
      </div>

      <div v-if="!accessViaQr" class="card">
        <h3>Batterie</h3>
        <p>{{ battery }}%</p>
      </div>

      <div class="card capacity-card">
        <h3>Capacité max</h3>
        <div class="capacity-container">
          <span class="capacity-indicator" :class="capacityIndicatorClass"></span>
          <span class="capacity-value">{{ maxPeople }}</span>
        </div>
      </div>

    </section>

    <PeopleChart ref="chartRef" />

    <div class="pmr-summary">
      PMR présents : {{ pmrPeople }}
    </div>
    <PassageHistory v-if="!accessViaQr" ref="historyRef" />

    <footer>
      MAJ : {{ timestamp }}
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick, watch } from 'vue'
import { io } from 'socket.io-client'

import Login from '@/components/Login.vue'
import PeopleChart from '@/components/PeopleChart.vue'
import Admin from '@/components/Admin.vue'
import PassageHistory from '@/components/PassageHistory.vue'
import QrOnly from '@/views/QrOnly.vue'

/* ================== CONSTANTES ================== */
// Clés de stockage navigateur utilisées pour garder un état local entre deux affichages.
const STORAGE_COUNTERS = 'supervision_counters_v1'
const STORAGE_CHART = 'supervision_chart_v1'
const STORAGE_HISTORY = 'passage_history_v1'
// URL du serveur Socket.IO et de l’API. Elles changent selon local/VPS.
const SOCKET_URL = import.meta.env.VITE_SOCKET_URL || 'http://178.32.107.35:3000'
const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || SOCKET_URL.replace(':3000', ':3001')
// Quand PUBLIC_MODE=true, on cache l’admin et on exige un accès QR.
const PUBLIC_MODE = import.meta.env.VITE_PUBLIC_MODE === 'true'

/* ================== AUTH ================== */
// État d’accès courant : login classique ou QR token validé.
const isAuthenticated = ref(false)
const isAdmin = ref(false)
const accessViaQr = ref(false)
const QR_ACCESS_KEY = 'qr_access_v1'
const QR_ACCESS_VERSION_KEY = 'qr_access_version'
// Évite d’afficher le login ou le dashboard avant d’avoir vérifié le token QR.
const isCheckingAccess = ref(true)

/* ================== DATA ================== */
// Données principales affichées dans les cartes.
const people = ref(0)
const entries = ref(0)
const exits = ref(0)
const battery = ref(100)
const maxPeople = ref(100)
const timestamp = ref('-')
const batteryStatus = ref('BATTERIE OK')
const pmrPeople = ref(0)

/* ================== REFS ================== */
// Références vers les composants enfants pour pouvoir les piloter depuis cette vue.
const chartRef = ref(null)
const historyRef = ref(null)
let socket = null
let refreshTimer = null

/* ================== ANTI DOUBLE PAR PORTE ================== */
// Debounce passages per door to avoid double counting.
const lastPassageByDoor = {}

/* ================== PERSISTENCE ================== */
// Ces fonctions sont gardées comme points d’extension si on veut réactiver
// la persistance locale du dashboard. Aujourd’hui la BDD reste la source fiable.
const loadCounters = () => {}

const saveCounters = () => {}

const loadChart = () => {}

const saveChart = () => {}

/* ================== API ================== */
// Petit wrapper pour centraliser les appels HTTP et remonter les erreurs API.
const fetchJson = async (path, options = {}) => {
  const response = await fetch(`${API_BASE_URL}${path}`, options)
  if (!response.ok) {
    throw new Error(`API ${response.status}`)
  }
  return response.json()
}

const hydrateFromApi = async () => {
  // Premier chargement complet : compteurs, graphe, puis historique admin.
  try {
    const state = await fetchJson('/api/dashboard/state')
    if (state) {
      if (state.people !== undefined) people.value = Number(state.people)
      if (state.entries !== undefined) entries.value = Number(state.entries)
      if (state.exits !== undefined) exits.value = Number(state.exits)
      if (state.battery !== undefined) {
        battery.value = Number(state.battery)
        batteryStatus.value =
          battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
      }
      if (state.pmrPeople !== undefined) {
        pmrPeople.value = Number(state.pmrPeople)
      }
      if (state.maxPeople !== undefined) maxPeople.value = Number(state.maxPeople)
      saveCounters()
      timestamp.value = new Date().toLocaleTimeString()
    }
  } catch (err) {
    console.warn('API dashboard/state indisponible', err)
  }

  if (chartRef.value) {
    // Reconstruit la courbe depuis les passages historiques stockés en BDD.
    try {
      const rows = await fetchJson('/api/dashboard/people-chart')
      chartRef.value.reset()
      rows.forEach(row => {
        const peopleValue = Number(row.people)
        if (!Number.isFinite(peopleValue)) return
        chartRef.value.addValue(peopleValue, maxPeople.value)
      })
    } catch (err) {
      console.warn('API dashboard/people-chart indisponible', err)
    }
  }

  if (historyRef.value) {
    // L’historique n’est affiché qu’en mode privé/admin.
    try {
      const rows = await fetchJson('/api/passage?limit=100')
      historyRef.value.resetHistory()
      const ordered = [...rows].reverse()
      ordered.forEach(row => {
        const dateValue = row.date_heure || row.ts
        const typeValue = row.type || row.mode_passage
        const appareilValue = row.appareil_id || row.capteur_id || row.capteur || '-'
        if (!dateValue || !typeValue) return
        historyRef.value.addEntry({
          date_heure: dateValue,
          type: typeValue,
          appareil_id: appareilValue
        })
      })
    } catch (err) {
      console.warn('API passage indisponible', err)
    }
  }
}

const refreshStateFromApi = async () => {
  // Actualisation légère toutes les 5 secondes pour garder le dashboard cohérent.
  try {
    const state = await fetchJson('/api/dashboard/state')
    if (state) {
      if (state.people !== undefined) people.value = Number(state.people)
      if (state.entries !== undefined) entries.value = Number(state.entries)
      if (state.exits !== undefined) exits.value = Number(state.exits)
      if (state.battery !== undefined) {
        battery.value = Number(state.battery)
        batteryStatus.value =
          battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
      }
      if (state.pmrPeople !== undefined) {
        pmrPeople.value = Number(state.pmrPeople)
      }
      if (state.maxPeople !== undefined) maxPeople.value = Number(state.maxPeople)
      timestamp.value = new Date().toLocaleTimeString()
    }
  } catch (err) {
    console.warn('API dashboard/state indisponible', err)
  }
}

const refreshChartFromApi = async () => {
  if (!chartRef.value) return

  // Recalcule la courbe depuis l’API pour éviter une dérive côté navigateur.
  try {
    const rows = await fetchJson('/api/dashboard/people-chart')
    chartRef.value.reset()
    rows.forEach(row => {
      const peopleValue = Number(row.people)
      if (!Number.isFinite(peopleValue)) return
      chartRef.value.addValue(peopleValue, maxPeople.value)
    })
    saveChart()
  } catch (err) {
    console.warn('API dashboard/people-chart indisponible', err)
  }
}

const updateMaxPeople = async (value) => {
  // La capacité maximale est sauvegardée côté API/BDD.
  maxPeople.value = Number(value)
  try {
    await fetchJson('/api/dashboard/max-people', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ maxPeople: maxPeople.value })
    })
  } catch (err) {
    console.warn('API dashboard/max-people indisponible', err)
  }
}

/* ================== TOKEN QR ================== */
const verifyAdminToken = async (token) => {
  // Vérifie que le lien QR scanné correspond à un token actif en base.
  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/verify?token=${encodeURIComponent(token)}`)
    if (!response.ok) return null
    return response.json()
  } catch {
    return null
  }
}

const fetchAdminVersion = async () => {
  // Permet d’invalider les anciennes sessions QR après un reset admin.
  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/version`)
    if (!response.ok) return null
    return response.json()
  } catch {
    return null
  }
}

onMounted(async () => {
  // 1. Récupère une éventuelle session QR déjà validée dans cet onglet.
  accessViaQr.value = sessionStorage.getItem(QR_ACCESS_KEY) === '1'
  if (accessViaQr.value) {
    isAuthenticated.value = true
  }

  const params = new URLSearchParams(window.location.search)
  const token = params.get('admin_token')
  if (token) {
    // 2. Si l’URL contient un token QR, on le valide côté API.
    const verifyResult = await verifyAdminToken(token)
    if (verifyResult?.ok) {
      accessViaQr.value = true
      sessionStorage.setItem(QR_ACCESS_KEY, '1')
      sessionStorage.setItem(QR_ACCESS_VERSION_KEY, String(verifyResult.version ?? 1))
      isAuthenticated.value = true
    }
  } else if (accessViaQr.value) {
    // 3. Si la session existait déjà, on vérifie qu’elle n’a pas été révoquée.
    const storedVersion = Number(sessionStorage.getItem(QR_ACCESS_VERSION_KEY) || '0')
    const versionResult = await fetchAdminVersion()
    if (!versionResult || storedVersion !== Number(versionResult.version)) {
      accessViaQr.value = false
      sessionStorage.removeItem(QR_ACCESS_KEY)
      sessionStorage.removeItem(QR_ACCESS_VERSION_KEY)
      isAuthenticated.value = false
    }
  }
  isCheckingAccess.value = false

  loadCounters()
  await nextTick()
  loadChart()
  await hydrateFromApi()

  // 4. Branche le temps réel : l’API relaie les événements capteurs en Socket.IO.
  socket = io(SOCKET_URL)

  socket.on('connect', () => console.log('Socket connecté'))

  socket.on('init', data => {
    maxPeople.value = data.maxPeople ?? maxPeople.value
    battery.value = data.bat ?? battery.value
  })

  socket.on('passage', data => handlePassage(data))

  socket.on('status', data => {
    if (data.battery !== undefined) {
      battery.value = data.battery
      batteryStatus.value =
        battery.value < 30 ? 'BATTERIE FAIBLE' : 'BATTERIE OK'
    }
    timestamp.value = new Date().toLocaleTimeString()
  })

  socket.on('config', data => {
    if (data.maxPeople !== undefined) maxPeople.value = data.maxPeople
  })

  refreshTimer = setInterval(() => {
    // 5. Sécurité supplémentaire : polling périodique même si le socket rate un event.
    refreshStateFromApi()
    refreshChartFromApi()
  }, 5 * 1000)
})

onBeforeUnmount(() => {
  socket?.disconnect()
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
})

/* ================== LOGIN ================== */
const handleLoginSuccess = () => {
  // Le login classique donne accès au dashboard privé et donc au bouton Admin.
  isAuthenticated.value = true
  accessViaQr.value = false
  sessionStorage.removeItem(QR_ACCESS_KEY)
  sessionStorage.removeItem(QR_ACCESS_VERSION_KEY)
}


watch(accessViaQr, (value) => {
  // Un accès QR ne doit jamais ouvrir le panneau admin.
  if (value) isAdmin.value = false
})

/* ================== PASSAGE HANDLER ================== */
const handlePassage = (data) => {
  // Les capteurs peuvent envoyer plusieurs phases : on ne compte que les passages terminés.
  const phase = data.type_passage ?? data.typePassage ?? data.phase
  if (phase && phase !== 'FIN') return

  // Anti double comptage très court par porte/capteur.
  const now = Date.now()
  const doorId = data.appareil_id ?? data.capteur_id ?? data.capteur ?? data.id ?? 'UNKNOWN'
  if (!lastPassageByDoor[doorId]) lastPassageByDoor[doorId] = 0
  if (now - lastPassageByDoor[doorId] < 300) return
  lastPassageByDoor[doorId] = now

  const passageType = data.type ?? data.mode_passage ?? data.mode
  const passageDate =
    data.date_heure ?? data.timestamp ?? data.ts ?? new Date().toISOString()

  // Met à jour l’état instantané côté navigateur pour un retour temps réel.
  if (passageType === 'ENTREE') {
    entries.value++
    people.value++
  } else if (passageType === 'SORTIE') {
    exits.value++
    people.value = Math.max(0, people.value - 1)
  }

  saveCounters()
  historyRef.value?.addEntry({
    date_heure: passageDate,
    type: passageType,
    appareil_id: doorId
  })
  chartRef.value?.addValue(people.value, maxPeople.value)
  saveChart()
  timestamp.value = new Date().toLocaleTimeString()
}

/* ================== ADMIN ACTIONS ================== */
const resetCounters = () => {
  // Reset local de l’affichage ; la logique BDD peut être complétée côté API si besoin.
  people.value = 0
  entries.value = 0
  exits.value = 0
  localStorage.removeItem(STORAGE_COUNTERS)
  localStorage.removeItem(STORAGE_CHART)
  historyRef.value?.resetHistory()
  chartRef.value?.reset()
}

/* ================== GENERATEUR ADMIN ================== */
const handleGeneratedPassage = (dataArray) => {
  // Outil de simulation : injecte des passages côté front pour démonstration/test.
  dataArray.forEach((data, index) => {
    setTimeout(() => {
      handlePassage({
        ...data,
        date_heure: new Date(Date.now() + index * 10).toISOString()
      })
    }, index * 50)
  })
}

/* ================== COMPUTED ================== */
// Classes d’état utilisées pour colorer les pastilles du header.
const statusBatteryClass = computed(() => ({
  ok: batteryStatus.value === 'BATTERIE OK',
  warn: batteryStatus.value === 'BATTERIE FAIBLE'
}))

const capacityIndicatorClass = computed(() => {
  // Seuils de capacité : libre, quasi plein à 90%, plein à 100%.
  if (people.value >= maxPeople.value) return 'max'
  if (people.value >= maxPeople.value * 0.9) return 'quasi'
  return 'ok'
})

const peopleStatus = computed(() => {
  if (people.value >= maxPeople.value) return 'PLEIN'
  if (people.value >= maxPeople.value * 0.9) return 'QUASI PLEIN'
  return 'LIBRE'
})
</script>

<style scoped>
.pmr-summary {
  margin: 10px 0 6px;
  padding: 10px 14px;
  border-radius: 10px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.12);
  font-size: 0.9rem;
  color: #e2e8f0;
}
</style>
