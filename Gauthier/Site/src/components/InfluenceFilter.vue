<template>
  <div class="card">
    <h3>Filtre temporel</h3>

    <div class="filter-grid">
      <div>
        <label>Du</label>
        <input type="datetime-local" v-model="from" />
      </div>

      <div>
        <label>Au</label>
        <input type="datetime-local" v-model="to" />
      </div>
    </div>

    <button class="admin-btn" @click="apply">
      Générer le graphe
    </button>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['apply'])

// Champs du filtre temporel envoyés au composant parent.
const from = ref('')
const to = ref('')

const apply = () => {
  // Ne lance pas de requête tant que les deux bornes ne sont pas renseignées.
  if (!from.value || !to.value) return
  emit('apply', {
    from: new Date(from.value),
    to: new Date(to.value)
  })
}
</script>

<style scoped>
.filter-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
}
</style>
