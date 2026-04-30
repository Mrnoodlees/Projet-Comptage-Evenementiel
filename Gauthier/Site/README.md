# comptage-evenementiel

Application web de supervision pour un systeme de comptage evenementiel.

Le projet permet de suivre en temps reel le nombre de personnes presentes sur un evenement, de consulter les entrees/sorties, de gerer des capteurs, de generer des acces par QR code et de separer une partie admin privee d'une partie publique.

## Idee Generale

Le projet est compose de trois blocs :

- Frontend Vue : interface visible dans le navigateur.
- API Node/Express : serveur qui recoit les requetes du site et parle a la BDD.
- Base PostgreSQL : stockage des passages, appareils, utilisateurs, QR tokens et reglages.

Flux simplifie :

```text
Navigateur Vue
  -> API Express
  -> PostgreSQL

Capteurs / source socket
  -> API Express
  -> Socket.IO
  -> Dashboard en temps reel
```

## Technologies

- `Vue 3` : framework frontend.
- `Vite` : serveur de developpement et outil de build.
- `Vue Router` : navigation entre les pages.
- `Chart.js` : graphiques d'affluence.
- `QRCode` : generation des QR codes.
- `Node.js` : runtime JavaScript cote serveur.
- `Express` : API HTTP.
- `PostgreSQL` : base de donnees.
- `Socket.IO` : temps reel entre l'API et le frontend.
- `dotenv` : lecture du fichier `.env`.
- `Apache` ou `Nginx` : hebergement en production.
- `SSH` / `autossh` : tunnels reseau entre PC local, BDD et VPS.

## Structure Des Dossiers

```text
Site/
  index.html                 Page HTML de base chargee par Vite
  package.json               Scripts npm et dependances
  vite.config.js             Configuration Vite
  .env                       Variables de configuration locale
  run.js                     Lance API + front ensemble
  run.sh                     Prepare les ports/tunnels puis lance le projet
  tunnels.sh                 Gere les tunnels SSH

  src/
    main.js                  Point d'entree du frontend
    App.vue                  Composant racine
    router/index.js          Configuration des routes
    mainstyle.css            Style global de l'application

    views/
      Dashboard.vue          Page principale dashboard/admin/public
      QrOnly.vue             Page qui demande de scanner un QR code
      PublicInfluence.vue    Page publique d'influence, prevue pour QR public

    components/
      Login.vue              Formulaire de connexion admin
      Admin.vue              Panneau d'administration
      PeopleChart.vue        Graphique du dashboard
      PassageHistory.vue     Historique des passages
      InfluenceView.vue      Analyse d'influence cote admin
      InfluenceChart.vue     Graphique d'influence
      InfluenceFilter.vue    Filtre de dates pour l'analyse

    backend/
      index.js               Point d'entree de l'API Express
      db.js                  Connexion PostgreSQL
      auth.js                Hash et verification des mots de passe
      qrTokens.js            Gestion des tokens QR
      doorSettings.js        Reglages par porte, dont PMR
      qrAccessVersion.js     Version d'acces pour invalider les QR

      routes/
        login.js             Connexion utilisateur
        passages.js          Lecture/ecriture des passages
        dashboard.js         Donnees du dashboard
        public.js            Donnees publiques d'influence
        admin.js             Actions admin
        qrAccess.js          Routes historiques d'acces QR

  deploy/
    apache/comptage.conf     Exemple de config Apache
    nginx/comptage.conf      Exemple de config Nginx
    systemd/comptage-api.service  Service Linux pour l'API
```

## Fonctionnement Du Routeur

Le routeur est dans `src/router/index.js`.

Il definit les pages accessibles par URL :

- `/` affiche `QrOnly.vue`
- `/dashboard` affiche `Dashboard.vue`

`App.vue` contient seulement :

```vue
<router-view />
```

Cela veut dire que `App.vue` laisse le routeur choisir quelle page afficher selon l'URL.

## Fonctionnement De Dashboard.vue

`Dashboard.vue` est la page centrale du projet.

Elle gere trois cas :

- Mode public : affiche une page QR si le token n'est pas valide.
- Mode prive : affiche le login si l'utilisateur n'est pas connecte.
- Mode dashboard : affiche les compteurs, graphiques, PMR et historique.

Elle fait aussi :

- verification du token QR avec `/api/admin/verify`
- recuperation de l'etat avec `/api/dashboard/state`
- recuperation de la courbe avec `/api/dashboard/people-chart`
- recuperation de l'historique avec `/api/passage`
- connexion Socket.IO pour recevoir les passages en temps reel
- rafraichissement automatique toutes les 5 secondes

## Fonctionnement De L'Admin

Le panneau admin est dans `src/components/Admin.vue`.

Il permet de :

- modifier la capacite maximale
- generer un QR code d'acces
- reset les acces QR
- creer un utilisateur de connexion
- consulter les statistiques par porte
- marquer une porte comme PMR
- gerer les appareils/capteurs
- lancer une analyse d'influence
- exporter l'analyse en `PNG` ou `CSV`

En mode public, le composant admin n'est pas affiche.

## Fonctionnement De L'API

L'API demarre depuis `src/backend/index.js`.

Elle :

- charge `.env`
- configure CORS
- active JSON avec `express.json()`
- connecte les routes `/api/...`
- lance un serveur HTTP sur `PORT`
- lance Socket.IO
- relaie les evenements d'une source Socket.IO externe si configuree

Routes principales :

- `POST /api/login`
- `GET /api/dashboard/state`
- `GET /api/dashboard/people-chart`
- `POST /api/dashboard/max-people`
- `GET /api/dashboard/door-stats`
- `GET /api/passage`
- `POST /api/passage`
- `GET /api/public/influence`
- `POST /api/admin/qr`
- `GET /api/admin/verify`
- `POST /api/admin/reset`
- `POST /api/admin/users`
- `GET /api/admin/appareils`
- `PATCH /api/admin/appareils/:id`
- `DELETE /api/admin/appareils/:id`

## Base De Donnees

La connexion PostgreSQL est geree dans `src/backend/db.js`.

Tables utilisees si elles existent :

- `log_passages`
- `passages`
- `passage`
- `appareils`
- `login`

Tables creees automatiquement si necessaire :

- `qr_tokens`
- `door_settings`
- `dashboard_settings`

Le code sait s'adapter a plusieurs noms de tables de passages. Par exemple, il peut lire `log_passages`, `passages` ou `passage`.

## Fichier .env

Le fichier `.env` sert a configurer le projet sans modifier le code.

Variables importantes :

```env
PORT=3001
DB_HOST=127.0.0.1
DB_PORT=25432
DB_NAME=projet_comptage
DB_USER=postgres
DB_PASSWORD=...

VITE_API_BASE_URL=http://localhost:3001
VITE_SOCKET_URL=http://localhost:3001
VITE_ALLOW_LOCAL_LOGIN=true

CORS_ORIGIN=http://localhost:5173,http://127.0.0.1:5173
```

Important : ne pas montrer les vrais mots de passe pendant une presentation.

## Commandes De Base

Installer les dependances :

```sh
npm install
```

Lancer seulement le frontend :

```sh
npm run dev -- --host 0.0.0.0 --port 5173
```

Lancer seulement l'API :

```sh
npm run api
```

Ou avec les tunnels et la preparation des ports (front + API ensemble) :

```sh
./run.sh
```

Compiler le site pour production :

```sh
npm run build
```

Previsualiser le build :

```sh
npm run preview
```

## Scenario Local Simple

Ce scenario est utile pour developper sur un PC.

1. Verifier `.env`.
2. Installer les dependances.
3. Lancer l'API.
4. Lancer le frontend.
5. Ouvrir le navigateur sur l'URL Vite, souvent `http://localhost:5173`.

Commandes :

```sh
npm install
npm run api
npm run dev
```

Ou tout ensemble :

```sh
./run.sh
```

## Scenario Avec VPS Publique

Objectif :

- PC local : API + BDD ou acces BDD
- VPS : site public
- navigateur public : appelle la VPS
- VPS : proxifie `/api` vers l'API

Le dossier `deploy/apache/comptage.conf` donne un exemple Apache.

Principe :

```text
Navigateur public
  -> VPS Apache
  -> /api proxifie vers API Node
  -> PostgreSQL
```

## Scripts SSH

`tunnels.sh` peut creer :

- un tunnel local vers la BDD
- un tunnel inverse vers la VPS

Le but est d'eviter d'exposer directement la BDD sur Internet.

## Build Et Deploiement

Compiler :

```sh
npm run build
```

Le resultat est dans :

```text
dist/
```

Ce dossier contient les fichiers statiques a servir avec Apache ou Nginx :

- `dist/index.html`
- `dist/assets/...`
- `dist/favicon.ico`
