<template>
  <div class="dashboard">

    <!-- HEADER -->
    <header>
      <h1>
        {{ mode === 'main' ? 'Administration' : 'Analyse d’influence' }}
      </h1>

      <button class="admin-btn" @click="handleBack">
        ← Retour
      </button>
    </header>

    <!-- ================= MODE ADMIN ================= -->
    <section v-if="mode === 'main'" class="cards admin-cards">

      <!-- Capacité max -->
      <div class="card">
        <h3>Capacité maximale</h3>

        <input
          type="number"
          min="1"
          v-model.number="localMaxPeople"
          class="transparent-input"
        />

        <button class="admin-btn capacity-save" @click="saveMaxPeople">
          Enregistrer
        </button>
      </div>

      <!-- Batterie -->
      <div class="card">
        <h3>Batterie</h3>
        <p>{{ battery }}%</p>
      </div>

      <!-- Reset -->
      <div class="card">
        <h3>Compteurs & historique</h3>

        <button class="admin-btn" @click="resetCounters">
          Réinitialiser
        </button>
      </div>

      <!-- Analyse -->
      <div class="card highlight">
        <h3>Analyse</h3>

        <button class="admin-btn" @click="mode = 'influence'">
          Analyse d’influence
        </button>
      </div>

      <!-- Appareils -->
      <div class="card">
        <h3>Appareils</h3>
        <p class="qr-hint">Modifier les paramètres des capteurs.</p>

        <button class="admin-btn" @click="mode = 'devices'">
          Gérer les appareils
        </button>
      </div>

      <!-- Portes -->
      <div class="card door-card">
        <h3>Portes</h3>
        <p class="qr-hint">Entrées / sorties par porte et marquage PMR.</p>

        <div v-if="isLoadingDoors" class="door-empty">Chargement...</div>
        <div v-else-if="doorError" class="door-empty">{{ doorError }}</div>
        <div v-else-if="!doorStats.length" class="door-empty">Aucune porte détectée</div>

        <div v-else class="door-list">
          <div v-for="door in doorStats" :key="door.door" class="door-row">
            <div class="door-main">
              <div class="door-name">{{ door.door }}</div>
              <div class="door-battery">Batterie : {{ formatBattery(door.battery) }}</div>
            </div>
            <div class="door-metrics">
              <span>Entrées : {{ door.entries }}</span>
              <span>Sorties : {{ door.exits }}</span>
              <span>Présents : {{ door.people }}</span>
            </div>
            <label class="door-pmr">
              <input
                type="checkbox"
                :checked="door.is_pmr"
                @change="togglePmr(door)"
              />
              PMR
            </label>
          </div>
        </div>

        <div v-if="hasLoadedDoors" class="door-meta">
          <span>MAJ : {{ lastDoorUpdate }}</span>
          <span v-if="isRefreshingDoors">Actualisation...</span>
        </div>

        <div v-if="pmrSummary" class="door-summary">
          <strong>PMR</strong>
          <span>Entrées : {{ pmrSummary.entries }}</span>
          <span>Sorties : {{ pmrSummary.exits }}</span>
          <span>Présents : {{ pmrSummary.people }}</span>
        </div>
      </div>

      <!-- QR Admin -->
      <div class="card">
        <h3>Accès Admin (QR)</h3>
        <p class="qr-hint">Scanne pour ouvrir la page admin.</p>

        <button class="admin-btn" @click="generateQr" :disabled="isGenerating">
          {{ isGenerating ? 'Génération...' : 'Générer le QR' }}
        </button>

        <button class="admin-btn" @click="resetQrAccess" :disabled="isResettingAccess">
          {{ isResettingAccess ? 'Reset...' : 'Reset accès QR' }}
        </button>

        <div v-if="qrDataUrl" class="qr-preview">
          <img :src="qrDataUrl" alt="QR Code Admin" />
          <p class="qr-url">{{ adminUrl }}</p>
          <p v-if="qrExpiresAt" class="qr-expire">
            Expire le {{ new Date(qrExpiresAt).toLocaleString() }}
          </p>
        </div>

        <p v-if="qrError" class="qr-error">{{ qrError }}</p>
        <p v-if="resetMessage" class="qr-expire">{{ resetMessage }}</p>
      </div>

      <!-- Identifiants -->
      <div class="card">
        <h3>Identifiants</h3>
        <p class="qr-hint">Créer un compte de connexion.</p>

        <input
          v-model="newUsername"
          type="text"
          placeholder="Utilisateur"
          class="transparent-input"
        />

        <input
          v-model="newPassword"
          type="password"
          placeholder="Mot de passe"
          class="transparent-input"
        />

        <button class="admin-btn" @click="createUser" :disabled="createUserLoading">
          {{ createUserLoading ? 'Création...' : 'Créer' }}
        </button>

        <p v-if="createUserError" class="qr-error">{{ createUserError }}</p>
        <p v-if="createUserMessage" class="qr-expire">{{ createUserMessage }}</p>
      </div>

    </section>

    <!-- ================= MODE ANALYSE ================= -->
    <section v-else-if="mode === 'influence'">
      <InfluenceView />
    </section>

    <!-- ================= MODE APPAREILS ================= -->
    <section v-else-if="mode === 'devices'" class="devices">
      <div class="card devices-card">
        <h3>Paramètres des appareils</h3>

        <div v-if="deviceLoading" class="door-empty">Chargement...</div>
        <div v-else-if="deviceError" class="door-empty">{{ deviceError }}</div>

        <div v-else class="devices-table">
          <div class="devices-head">
            <span>Id</span>
            <span>Lien</span>
            <span>Sensibilité</span>
            <span>Role F</span>
            <span>Role B</span>
            <span>Temps bloqué</span>
            <span>Dernière vue</span>
            <span></span>
          </div>

          <div v-for="device in devices" :key="device.id" class="devices-row">
            <span class="device-id">{{ device.id }}</span>
            <span class="device-link">
              <a
                v-if="deviceLink(device.id)"
                :href="deviceLink(device.id)"
                target="_blank"
                rel="noopener noreferrer"
              >
                {{ deviceLink(device.id) }}
              </a>
              <span v-else>—</span>
            </span>
            <input v-model.number="device.sensibilite" type="number" />
            <select v-model="device.role_f">
              <option value="">—</option>
              <option value="ENTREE">ENTREE</option>
              <option value="SORTIE">SORTIE</option>
            </select>
            <select v-model="device.role_b">
              <option value="">—</option>
              <option value="ENTREE">ENTREE</option>
              <option value="SORTIE">SORTIE</option>
            </select>
            <input v-model.number="device.temps_bloque" type="number" />
            <span class="device-date">{{ formatDate(device.derniere_vu) }}</span>
            <div class="device-actions">
              <button class="admin-btn" @click="saveDevice(device)" :disabled="device._saving">
                {{ device._saving ? '...' : 'Enregistrer' }}
              </button>
              <button class="admin-btn danger" @click="deleteDevice(device)" :disabled="device._saving">
                Supprimer
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

  </div>
</template>

<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import QRCode from 'qrcode'
import InfluenceView from '@/components/InfluenceView.vue'

// Suffixe utilisé pour construire un lien local vers un appareil/capteur.
const DEVICE_HOST_SUFFIX = import.meta.env.VITE_DEVICE_HOST_SUFFIX || '.local'

/* ================== EMITS ================== */
const emit = defineEmits([
  'update:maxPeople',
  'resetCounters',
  'resetBattery',
  'generatePassage',
  'back'
])

/* ================== PROPS ================== */
// L’admin reçoit la capacité et la batterie depuis Dashboard.vue.
const props = defineProps({
  maxPeople: Number,
  battery: Number
})

/* ================== STATE ================== */
// Toggles between admin controls, influence view, and device editor.
const mode = ref('main')
// Local input state for max capacity.
const localMaxPeople = ref(props.maxPeople)
// Number of fake passages to generate.
const generatedCount = ref(1)
// QR content for admin access.
const adminUrl = ref('')
const qrDataUrl = ref('')
const qrError = ref('')
const isGenerating = ref(false)
const qrExpiresAt = ref(null)
// API appelée par les actions d’administration.
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || window.location.origin
// URL encodée dans le QR : elle doit pointer vers le dashboard public/VPS.
const PUBLIC_DASHBOARD_URL = 'http://178.32.107.35:5173'
const isResettingAccess = ref(false)
const resetMessage = ref('')
// Formulaire de création d’identifiants.
const newUsername = ref('')
const newPassword = ref('')
const createUserLoading = ref(false)
const createUserError = ref('')
const createUserMessage = ref('')
// Aggregated stats per door.
const doorStats = ref([])
const pmrSummary = ref(null)
const isLoadingDoors = ref(false)
const doorError = ref('')
const hasLoadedDoors = ref(false)
const isRefreshingDoors = ref(false)
const lastDoorUpdate = ref('')
let doorTimer = null
const devices = ref([])
const deviceLoading = ref(false)
const deviceError = ref('')

/* ================== WATCH ================== */
watch(
  () => props.maxPeople,
  v => (localMaxPeople.value = v)
)

/* ================== ACTIONS ================== */
const saveMaxPeople = () => {
  // Envoie la nouvelle capacité au parent, qui la sauvegarde via l’API dashboard.
  emit('update:maxPeople', localMaxPeople.value)
}

const resetCounters = () => {
  // Protection simple contre un reset involontaire pendant une démonstration.
  if (confirm('Confirmer la réinitialisation des compteurs et de l’historique ?')) {
    emit('resetCounters')
  }
}

const resetBattery = () => {
  // Action locale exposée au parent si l’on veut simuler une batterie pleine.
  emit('resetBattery')
}

/* ================== GÉNÉRATION ================== */
const generateEntries = () => {
  // Génère de faux événements d’entrée pour tester le dashboard sans capteur.
  emit(
    'generatePassage',
    Array.from({ length: generatedCount.value }, () => ({
      type_passage: 'FIN',
      type: 'ENTREE',
      appareil_id: 'ADMIN'
    }))
  )
}

const generateExits = () => {
  // Génère de faux événements de sortie pour tester le dashboard sans capteur.
  emit(
    'generatePassage',
    Array.from({ length: generatedCount.value }, () => ({
      type_passage: 'FIN',
      type: 'SORTIE',
      appareil_id: 'ADMIN'
    }))
  )
}

/* ================== QR CODE ================== */
const generateQr = async () => {
  // Demande à l’API un token persistant, puis génère une image QR côté navigateur.
  qrError.value = ''
  isGenerating.value = true

  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/qr`, {
      method: 'POST'
    })
    if (!response.ok) {
      qrError.value = 'Impossible de générer le QR (API)'
      return
    }

    const { token, expiresAt } = await response.json()
    adminUrl.value = `${PUBLIC_DASHBOARD_URL}/dashboard?admin_token=${token}`
    qrExpiresAt.value = expiresAt
    qrDataUrl.value = await QRCode.toDataURL(adminUrl.value, {
      width: 240,
      margin: 1
    })
  } catch (err) {
    qrError.value = 'Impossible de générer le QR'
  } finally {
    isGenerating.value = false
  }
}

const resetQrAccess = async () => {
  // Invalide les sessions QR déjà ouvertes en augmentant la version d’accès.
  resetMessage.value = ''
  isResettingAccess.value = true

  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/reset`, {
      method: 'POST'
    })

    if (!response.ok) {
      resetMessage.value = 'Échec du reset'
      return
    }

    resetMessage.value = 'Accès QR réinitialisés'
  } catch {
    resetMessage.value = 'Échec du reset'
  } finally {
    isResettingAccess.value = false
  }
}

const createUser = async () => {
  // Crée un compte dans la table login. Le backend hash le mot de passe.
  createUserError.value = ''
  createUserMessage.value = ''

  const username = String(newUsername.value || '').trim()
  const password = String(newPassword.value || '')

  if (!username || !password) {
    createUserError.value = 'Utilisateur et mot de passe requis'
    return
  }

  createUserLoading.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    })

    if (response.status === 409) {
      createUserError.value = 'Utilisateur déjà existant'
      return
    }

    if (!response.ok) {
      createUserError.value = 'Impossible de créer l’utilisateur'
      return
    }

    createUserMessage.value = 'Identifiant créé'
    newPassword.value = ''
  } catch {
    createUserError.value = 'Impossible de créer l’utilisateur'
  } finally {
    createUserLoading.value = false
  }
}

/* ================== PORTES ================== */
// Fetch door stats and PMR summary from the API.
const loadDoorStats = async () => {
  // Récupère les compteurs par porte et le total PMR depuis la BDD.
  const isFirstLoad = !hasLoadedDoors.value
  if (isFirstLoad) {
    isLoadingDoors.value = true
  } else {
    isRefreshingDoors.value = true
  }
  doorError.value = ''

  try {
    const response = await fetch(`${API_BASE_URL}/api/dashboard/door-stats`)
    if (!response.ok) {
      doorError.value = 'Impossible de charger les portes'
      return
    }

    const payload = await response.json()
    doorStats.value = payload.doors || []
    pmrSummary.value = payload.pmr || { entries: 0, exits: 0, people: 0 }
    hasLoadedDoors.value = true
    lastDoorUpdate.value = new Date().toLocaleTimeString()
  } catch {
    doorError.value = 'Impossible de charger les portes'
  } finally {
    isLoadingDoors.value = false
    isRefreshingDoors.value = false
  }
}

// Persist PMR flag for a given door.
const togglePmr = async (door) => {
  // Optimistic UI : on coche/décoche tout de suite, puis on annule si l’API refuse.
  const nextValue = !door.is_pmr
  door.is_pmr = nextValue

  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/door-pmr`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ doorId: door.door, isPmr: nextValue })
    })

    if (!response.ok) {
      door.is_pmr = !nextValue
    } else {
      loadDoorStats()
    }
  } catch {
    door.is_pmr = !nextValue
  }
}

const formatBattery = (value) => {
  // Normalise l’affichage batterie même si la valeur BDD est absente.
  const numeric = Number(value)
  if (!Number.isFinite(numeric)) return '--'
  return `${numeric}%`
}

// Device table helpers.
const formatDate = (value) => {
  // Rend les dates de dernière connexion plus lisibles pour l’admin.
  if (!value) return '-'
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? '-' : date.toLocaleString()
}

const deviceLink = (id) => {
  // Transforme un identifiant appareil en lien web local, par exemple capteur-1.local.
  const safeId = String(id || '').trim()
  if (!safeId) return ''
  const host = safeId.includes('.') ? safeId : `${safeId}${DEVICE_HOST_SUFFIX}`
  return `http://${host}/`
}

const loadDevices = async () => {
  // Charge la table appareils pour pouvoir modifier les paramètres capteurs.
  deviceLoading.value = true
  deviceError.value = ''

  try {
    const response = await fetch(`${API_BASE_URL}/api/admin/appareils`)
    if (!response.ok) {
      deviceError.value = 'Impossible de charger les appareils'
      return
    }
    devices.value = await response.json()
  } catch {
    deviceError.value = 'Impossible de charger les appareils'
  } finally {
    deviceLoading.value = false
  }
}

const saveDevice = async (device) => {
  // Sauvegarde uniquement les champs modifiables depuis l’interface.
  device._saving = true
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/admin/appareils/${encodeURIComponent(device.id)}`,
      {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          sensibilite: device.sensibilite,
          role_f: device.role_f,
          role_b: device.role_b,
          temps_bloque: device.temps_bloque
        })
      }
    )
    if (!response.ok) {
      deviceError.value = 'Erreur de sauvegarde'
    }
  } catch {
    deviceError.value = 'Erreur de sauvegarde'
  } finally {
    device._saving = false
  }
}

const deleteDevice = async (device) => {
  // Suppression contrôlée : confirmation obligatoire avant appel API.
  if (!confirm(`Supprimer l’appareil ${device.id} ?`)) return

  device._saving = true
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/admin/appareils/${encodeURIComponent(device.id)}`,
      { method: 'DELETE' }
    )
    if (!response.ok) {
      deviceError.value = 'Erreur de suppression'
      return
    }
    devices.value = devices.value.filter((item) => item.id !== device.id)
  } catch {
    deviceError.value = 'Erreur de suppression'
  } finally {
    device._saving = false
  }
}

/* ================== NAV ================== */
const handleBack = () => {
  // Retour contextuel : d’abord vers le menu admin, puis vers le dashboard.
  if (mode.value === 'influence' || mode.value === 'devices') {
    mode.value = 'main'
  } else {
    emit('back')
  }
}

onMounted(() => {
  // Les stats portes sont utiles dès l’ouverture de l’admin et restent rafraîchies.
  loadDoorStats()
  doorTimer = setInterval(loadDoorStats, 5 * 1000)
})

watch(mode, (value) => {
  // Les appareils ne sont chargés que quand l’admin ouvre l’onglet concerné.
  if (value === 'devices') {
    loadDevices()
  }
})

onBeforeUnmount(() => {
  // Nettoie le timer pour éviter les appels API après fermeture du composant.
  if (doorTimer) {
    clearInterval(doorTimer)
    doorTimer = null
  }
})
</script>

<style scoped>
.qr-hint {
  font-size: 12px;
  color: #94a3b8;
  margin-bottom: 8px;
}

.qr-card {
  text-align: left;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.qr-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.qr-preview {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: center;
}

.qr-preview img {
  width: 180px;
  height: 180px;
  background: white;
  padding: 6px;
  border-radius: 8px;
}

.qr-url {
  font-size: 11px;
  color: #94a3b8;
  word-break: break-all;
  text-align: center;
}

.qr-expire {
  font-size: 11px;
  color: #94a3b8;
}

.qr-error {
  margin-top: 8px;
  font-size: 12px;
  color: #dc2626;
}

.admin-cards {
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
}

.admin-cards .card {
  min-height: 210px;
}

.capacity-save {
  margin-top: 12px;
}

.door-list {
  display: grid;
  gap: 10px;
  margin-top: 10px;
}

.door-card {
  text-align: left;
}

@media (min-width: 1100px) {
  .door-card {
    grid-column: span 2;
  }

  .qr-card {
    grid-column: span 2;
  }
}

.door-row {
  display: grid;
  grid-template-columns: 1fr auto auto;
  gap: 12px;
  align-items: center;
  padding: 10px 12px;
  border-radius: 10px;
  background: rgba(15, 23, 42, 0.5);
  border: 1px solid rgba(148, 163, 184, 0.12);
}

.door-name {
  font-weight: 600;
}

.door-main {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.door-battery {
  font-size: 0.78rem;
  color: #94a3b8;
}

.door-metrics {
  display: flex;
  gap: 10px;
  font-size: 0.8rem;
  color: #cbd5e1;
  flex-wrap: wrap;
}

.door-pmr {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.8rem;
  color: #cbd5e1;
}

.door-summary {
  margin-top: 12px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  font-size: 0.8rem;
  color: #e2e8f0;
}

.door-meta {
  margin-top: 10px;
  display: flex;
  gap: 12px;
  font-size: 0.75rem;
  color: #94a3b8;
}

.door-empty {
  font-size: 0.8rem;
  color: #94a3b8;
  margin-top: 8px;
}

.devices-card {
  text-align: left;
}

.devices-table {
  display: grid;
  gap: 10px;
  margin-top: 12px;
}

.devices-head,
.devices-row {
  display: grid;
  grid-template-columns: 1.2fr 1.8fr repeat(4, 1fr) 1.2fr 0.9fr;
  gap: 8px;
  align-items: center;
}

.devices-head {
  font-size: 0.75rem;
  color: #94a3b8;
  text-transform: uppercase;
}

.devices-row input,
.devices-row select {
  width: 100%;
  padding: 6px 8px;
  border-radius: 8px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(15, 23, 42, 0.5);
  color: #e2e8f0;
}

.device-actions {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.admin-btn.danger {
  background: rgba(220, 38, 38, 0.2);
  border-color: rgba(220, 38, 38, 0.4);
  color: #fecaca;
}

.admin-btn.danger:hover {
  background: rgba(220, 38, 38, 0.35);
}

.device-id {
  font-weight: 600;
  color: #e2e8f0;
}

.device-link a {
  color: #93c5fd;
  text-decoration: none;
  font-size: 0.82rem;
  word-break: break-all;
}

.device-link a:hover {
  text-decoration: underline;
}

.device-date {
  font-size: 0.78rem;
  color: #94a3b8;
}

@media (max-width: 1100px) {
  .devices-head {
    display: none;
  }

  .devices-row {
    grid-template-columns: 1fr;
    gap: 6px;
    padding: 10px 12px;
    border-radius: 10px;
    background: rgba(15, 23, 42, 0.5);
    border: 1px solid rgba(148, 163, 184, 0.12);
  }
}

@media (max-width: 720px) {
  .door-row {
    grid-template-columns: 1fr;
    align-items: flex-start;
  }

  .door-metrics {
    flex-direction: column;
  }

  .door-meta {
    flex-direction: column;
  }
}
</style>
