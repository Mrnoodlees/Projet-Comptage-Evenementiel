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
    <section v-if="mode === 'main'" class="cards">

      <!-- Capacité max -->
      <div class="card">
        <h3>Capacité maximale</h3>

        <input
          type="number"
          min="1"
          v-model.number="localMaxPeople"
          class="transparent-input"
        />

        <button class="admin-btn" @click="saveMaxPeople">
          Enregistrer
        </button>
      </div>

      <!-- Batterie -->
      <div class="card">
        <h3>Batterie</h3>
        <p>{{ battery }}%</p>

        <button class="admin-btn" @click="resetBattery">
          Recharger batterie
        </button>
      </div>

      <!-- Génération de données -->
      <div class="card">
        <h3>Génération de passages</h3>

        <input
          type="number"
          min="1"
          v-model.number="generatedCount"
          class="transparent-input"
        />

        <button class="admin-btn" @click="generateEntries">
          Générer entrées
        </button>

        <button class="admin-btn" @click="generateExits">
          Générer sorties
        </button>
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

    </section>

    <!-- ================= MODE ANALYSE ================= -->
    <section v-else>
      <InfluenceView />
    </section>

  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import QRCode from 'qrcode'
import InfluenceView from '@/components/InfluenceView.vue'

/* ================== EMITS ================== */
const emit = defineEmits([
  'update:maxPeople',
  'resetCounters',
  'resetBattery',
  'generatePassage',
  'back'
])

/* ================== PROPS ================== */
const props = defineProps({
  maxPeople: Number,
  battery: Number
})

/* ================== STATE ================== */
const mode = ref('main')
const localMaxPeople = ref(props.maxPeople)
const generatedCount = ref(1)
const adminUrl = ref('')
const qrDataUrl = ref('')
const qrError = ref('')
const isGenerating = ref(false)
const qrExpiresAt = ref(null)
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || window.location.origin
const isResettingAccess = ref(false)
const resetMessage = ref('')

/* ================== WATCH ================== */
watch(
  () => props.maxPeople,
  v => (localMaxPeople.value = v)
)

/* ================== ACTIONS ================== */
const saveMaxPeople = () => {
  emit('update:maxPeople', localMaxPeople.value)
}

const resetCounters = () => {
  if (confirm('Confirmer la réinitialisation des compteurs et de l’historique ?')) {
    emit('resetCounters')
  }
}

const resetBattery = () => {
  emit('resetBattery')
}

/* ================== GÉNÉRATION ================== */
const generateEntries = () => {
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
    adminUrl.value = `${window.location.origin}/dashboard?admin_token=${token}`
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

/* ================== NAV ================== */
const handleBack = () => {
  if (mode.value === 'influence') {
    mode.value = 'main'
  } else {
    emit('back')
  }
}
</script>

<style scoped>
.qr-hint {
  font-size: 12px;
  color: #94a3b8;
  margin-bottom: 8px;
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
</style>
