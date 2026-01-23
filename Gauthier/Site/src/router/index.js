import { createRouter, createWebHistory } from 'vue-router'

import Dashboard from '@/views/Dashboard.vue'
import PublicInfluence from '@/views/PublicInfluence.vue'

const routes = [
  {
    path: '/dashboard',
    name: 'dashboard',
    component: Dashboard
  },
  {
    path: '/',
    name: 'PublicInfluence',
    component: () => import('@/views/PublicInfluence.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
