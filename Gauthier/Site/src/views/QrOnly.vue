<template>
  <div class="qr-only">
    <div class="qr-card">
      <h1>Accès sécurisé</h1>
      <p>Cette page n’est accessible que via un QR code.</p>
      <p class="qr-hint">Scanne le QR fourni par l’administrateur.</p>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped>
.qr-only {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 24px;
}

.qr-card {
  max-width: 420px;
  text-align: center;
  padding: 28px 24px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: var(--shadow-md);
}

.qr-card h1 {
  margin: 0 0 12px;
  font-size: 1.2rem;
}

.qr-card p {
  margin: 0;
  color: var(--muted);
}

.qr-hint {
  margin-top: 8px;
  font-size: 0.9rem;
}
</style>
