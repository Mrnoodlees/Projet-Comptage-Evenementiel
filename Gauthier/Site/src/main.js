import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './mainstyle.css'

// Point d’entrée du frontend :
// - charge le composant racine App.vue
// - branche le routeur Vue
// - applique le style global du dashboard
createApp(App)
  .use(router)
  .mount('#app')
