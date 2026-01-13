<template>
  <div class="login-container">
    <div class="login-card">
      <h2>Connexion</h2>

      <input
        v-model="username"
        type="text"
        placeholder="Utilisateur"
        class="login-input"
      />

      <input
        v-model="password"
        type="password"
        placeholder="Mot de passe"
        class="login-input"
      />

      <p v-if="error" class="error">{{ error }}</p>

      <button @click="login">Se connecter</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['success'])

const username = ref('')
const password = ref('')
const error = ref('')

const login = () => {
  error.value = ''

  // 🔐 Auth simple (à remplacer par API plus tard)
  if (username.value === 'admin' && password.value === 'admin') {
    emit('success')
  } else {
    error.value = 'Identifiants incorrects'
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  background: #0f172a;
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-card {
  background: #1e293b;
  padding: 24px;
  border-radius: 16px;
  width: 280px;
  text-align: center;
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

.login-card h2 {
  margin-bottom: 16px;
  color: #e5e7eb;
}

.login-input {
  width: 92%;
  margin-bottom: 10px;
  padding: 8px 10px;
  border-radius: 10px;
  border: none;
  background: #334155;
  color: #e5e7eb;
}

.login-input::placeholder {
  color: #94a3b8;
}

button {
  width: 100%;
  padding: 8px;
  border-radius: 10px;
  border: none;
  background: #2563eb;
  color: white;
  font-weight: 600;
  cursor: pointer;
}

button:hover {
  background: #1d4ed8;
}

.error {
  font-size: 0.75rem;
  color: #dc2626;
  margin-bottom: 8px;
}
</style>
