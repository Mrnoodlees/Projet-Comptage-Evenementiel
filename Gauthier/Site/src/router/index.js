import { createRouter, createWebHistory } from 'vue-router'

import Dashboard from '@/views/Dashboard.vue'
import QrOnly from '@/views/QrOnly.vue'

// Routes principales de l’application.
// /dashboard contient la supervision et l’admin selon le mode d’accès.
// / affiche une page d’attente indiquant que l’accès se fait par QR code.
const routes = [
  {
    path: '/dashboard',
    name: 'dashboard',
    component: Dashboard
  },
  {
    path: '/',
    name: 'home',
    component: QrOnly
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
