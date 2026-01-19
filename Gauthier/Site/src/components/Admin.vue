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

      <!-- Compteurs & Historique -->
      <div class="admin-card danger">
        <h3>Compteurs & historique</h3>
        <button class="action-btn danger" @click="resetCounters">
          Réinitialiser
        </button>
      </div>

      <!-- Générateur passages fictifs -->
      <div class="admin-card generator-card">
        <h3>Générateur de passages</h3>

        <label>
          Nombre de passages :
          <input type="number" v-model.number="count" min="1" class="admin-input" />
        </label>

        <label>
          Type :
          <select v-model="type" class="admin-input">
            <option value="ENTREE">ENTREE</option>
            <option value="SORTIE">SORTIE</option>
            <option value="RANDOM">ALÉATOIRE</option>
          </select>
        </label>

        <label>
          Porte :
          <input type="text" v-model="door" placeholder="Ex: PORTE_01" class="admin-input" />
        </label>

        <button class="action-btn" @click="generateData">Générer</button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

/* Props / emits */
const props = defineProps({
  maxPeople: Number,
  battery: Number
})
const emit = defineEmits([
  'update:maxPeople',
  'resetCounters',
  'resetBattery',
  'back',
  'generatePassage'
])

/* Local max people */
const localMaxPeople = ref(props.maxPeople)
watch(() => props.maxPeople, val => (localMaxPeople.value = val))
const saveMaxPeople = () => emit('update:maxPeople', localMaxPeople.value)

/* Reset compteurs */
const resetCounters = () => {
  if (confirm('Confirmer la réinitialisation des compteurs et de l’historique ?')) {
    emit('resetCounters')
  }
}

/* Reset batterie */
const resetBattery = () => emit('resetBattery')

/* === Générateur passages fictifs === */
const count = ref(5)
const type = ref('RANDOM')
const door = ref('PORTE_01')

const generateData = () => {
  const generated = []
  for (let i = 0; i < count.value; i++) {
    const passageType =
      type.value === 'RANDOM' ? (Math.random() < 0.5 ? 'ENTREE' : 'SORTIE') : type.value
    generated.push({
      type_passage: 'FIN',
      type: passageType,
      appareil_id: door.value || `PORTE_${Math.floor(Math.random() * 5 + 1)}`,
      date_heure: new Date().toISOString()
    })
  }
  emit('generatePassage', generated)
}

</script>

<style scoped>
.admin {
  color: #e5e7eb;
  font-family: system-ui, Arial, sans-serif;
  padding: 16px;
  max-width: 1200px;
  margin: auto;
}

/* Header */
.admin-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}

.admin-header h1 {
  font-size: 1.1rem;
}

.back-btn {
  margin-left: auto;
  padding: 6px 12px;
  border-radius: 10px;
  border: none;
  background: #334155;
  color: #e5e7eb;
  font-size: 0.75rem;
  cursor: pointer;
  transition: background 0.2s;
}

.back-btn:hover {
  background: #475569;
}

/* Grille cartes */
.admin-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

/* Carte */
.admin-card {
  background: #1e293b;
  padding: 12px;
  border-radius: 12px;
  text-align: center;
}

.admin-card h3 {
  font-size: 0.8rem;
  margin-bottom: 8px;
}

/* Input */
.admin-input {
  width: 100%;
  box-sizing: border-box;
  padding: 6px 8px;
  border-radius: 8px;
  border: none;
  background: #1e293b;
  color: #e5e7eb;
  text-align: center;
  font-weight: 600;
  margin-bottom: 8px;
}

/* Boutons */
.action-btn {
  width: 100%;
  padding: 6px 12px;
  border-radius: 10px;
  border: none;
  background: #2563eb;
  color: #e5e7eb;
  font-size: 0.75rem;
  cursor: pointer;
  transition: opacity 0.2s;
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

/* Carte générateur */
.generator-card label {
  display: block;
  margin-bottom: 6px;
  font-size: 0.75rem;
}
</style>
