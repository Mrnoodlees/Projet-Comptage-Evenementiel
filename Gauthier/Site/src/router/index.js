import { createRouter, createWebHistory } from 'vue-router'

import Dashboard from '@/views/Dashboard.vue'
import QrOnly from '@/views/QrOnly.vue'

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
