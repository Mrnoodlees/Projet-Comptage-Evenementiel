<template>
  <div class="admin">
    <header class="admin-header">
      <h1>Administration</h1>
      <button class="back-btn" @click="$emit('back')">← Retour</button>
    </header>

    <section class="admin-cards">
      <!-- Capacité max -->
      <div class="admin-card">
        <h3>Capacité maximale</h3>
        <input
          type="number"
          v-model.number="localMaxPeople"
          min="1"
          class="admin-input"
        />
        <button class="action-btn" @click="saveMaxPeople">
          Enregistrer
        </button>
      </div>

      <!-- Batterie -->
      <div class="admin-card">
        <h3>Batterie</h3>
        <p>{{ battery }}%</p>
        <button class="action-btn warn" @click="resetBattery">
          Recharger batterie
        </button>
      </div>

      <!-- Compteurs -->
      <div class="admin-card danger">
        <h3>Compteurs</h3>
        <button class="action-btn danger" @click="resetCounters">
          Réinitialiser
        </button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const emit = defineEmits([
  'update:maxPeople',
  'resetCounters',
  'resetBattery',
  'back'
])

const props = defineProps({
  maxPeople: Number,
  battery: Number
})

const localMaxPeople = ref(props.maxPeople)

watch(
  () => props.maxPeople,
  (val) => (localMaxPeople.value = val)
)

const saveMaxPeople = () => {
  emit('update:maxPeople', localMaxPeople.value)
}

const resetCounters = () => {
  if (confirm('Confirmer la réinitialisation des compteurs ?')) {
    emit('resetCounters')
  }
}

const resetBattery = () => {
  emit('resetBattery')
}
</script>

<style scoped>
.admin {
  min-height: 100vh;
  background: #0f172a;
  color: #e5e7eb;
  padding: 16px;
  max-width: 800px;
  margin: auto;
}

.admin-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.admin-header h1 {
  font-size: 1.1rem;
}

.back-btn {
  margin-left: auto;
  background: #334155;
  border: none;
  border-radius: 10px;
  padding: 6px 12px;
  color: #e5e7eb;
  cursor: pointer;
}

.back-btn:hover {
  background: #475569;
}

.admin-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 14px;
}

.admin-card {
  background: #1e293b;
  border-radius: 14px;
  padding: 16px;
  text-align: center;
}

.admin-card h3 {
  font-size: 0.85rem;
  margin-bottom: 10px;
}

.admin-input {
  width: 100%;
  padding: 8px;
  border-radius: 10px;
  border: none;
  background: #0f172a;
  color: #e5e7eb;
  text-align: center;
  font-weight: 600;
  margin-bottom: 10px;
}

.action-btn {
  width: 100%;
  padding: 8px;
  border-radius: 10px;
  border: none;
  background: #2563eb;
  color: white;
  cursor: pointer;
  font-size: 0.75rem;
}

.action-btn:hover {
  opacity: 0.9;
}

.action-btn.warn {
  background: #facc15;
  color: #0f172a;
}

.action-btn.danger {
  background: #dc2626;
}

.admin-card.danger {
  border: 1px solid #dc2626;
}
</style>
