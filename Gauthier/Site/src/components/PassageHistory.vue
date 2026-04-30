<template>
  <div class="card history-card">
    <h3>Historique des passages</h3>

    <div v-if="history.length === 0" class="empty">
      Aucun passage enregistré
    </div>

    <ul class="history-list">
      <li v-for="(item, index) in history" :key="index">
        <span class="time">{{ item.time }}</span>
        <span class="door">{{ item.door }}</span>
        <span class="type" :class="item.type.toLowerCase()">
          {{ item.type }}
        </span>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

/* ================== CONSTANTES ================== */
const MAX_HISTORY = 100
const HISTORY_KEY = 'passage_history_v1'

/* ================== STATE ================== */
const history = ref([])

/* ================== LIFECYCLE ================== */
onMounted(() => {
  const saved = localStorage.getItem(HISTORY_KEY)
  if (saved) {
    history.value = JSON.parse(saved)
  }
})

/* ================== METHODS ================== */
const persist = () => {
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history.value))
}

const addEntry = (data) => {
  history.value.unshift({
    time: new Date(data.date_heure).toLocaleTimeString(),
    door: data.appareil_id,
    type: data.type
  })

  if (history.value.length > MAX_HISTORY) {
    history.value.pop()
  }

  persist()
}

const resetHistory = () => {
  history.value = []
  localStorage.removeItem(HISTORY_KEY)
}

/* ================== EXPOSE ================== */
defineExpose({
  addEntry,
  resetHistory
})
</script>

<style scoped>
.history-card {
  max-height: 350px;
  overflow: hidden;
}

.history-list {
  list-style: none;
  padding: 0;
  margin: 0;
  max-height: 280px;
  overflow-y: auto;
}

.history-list li {
  display: flex;
  gap: 10px;
  padding: 6px 0;
  font-size: 14px;
  border-bottom: 1px solid #e5e7eb33;
}

.time {
  width: 80px;
  font-family: monospace;
}

.door {
  font-weight: bold;
}

.type {
  margin-left: auto;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
}

.type.entree {
  background: #e6f7ee;
  color: #1b7f4d;
}

.type.sortie {
  background: #fdecea;
  color: #b42318;
}

.empty {
  font-size: 14px;
  color: #94a3b8;
}

@media (max-width: 600px) {
  .history-list li {
    flex-wrap: wrap;
    gap: 6px;
    font-size: 12px;
  }

  .time {
    width: 60px;
  }

  .door {
    max-width: 140px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .type {
    margin-left: 0;
  }
}
</style>
