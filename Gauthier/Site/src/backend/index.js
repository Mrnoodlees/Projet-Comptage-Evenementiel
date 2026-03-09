// index.js
import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import http from 'node:http'
import { spawn } from 'node:child_process'
import crypto from 'node:crypto'
import { Server as SocketIOServer } from 'socket.io'
import { io as ioClient } from 'socket.io-client'
import passagesRoutes from './routes/passages.js'
import dashboardRoutes from './routes/dashboard.js'
import publicRoutes from './routes/public.js'
import loginRoutes from './routes/login.js'
import adminRoutes from './routes/admin.js'

dotenv.config()

const app = express()

const corsOrigins = (process.env.CORS_ORIGIN || '')
  .split(',')
  .map(origin => origin.trim())
  .filter(Boolean)

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || corsOrigins.length === 0 || corsOrigins.includes(origin)) {
      return callback(null, true)
    }
    return callback(new Error(`Origine non autorisée: ${origin}`))
  }
}

app.use(cors(corsOptions))
app.use(express.json())

/* ================= HTTP LOGGER ================= */
app.use((req, res, next) => {
  const start = Date.now()
  const requestId = crypto.randomUUID()
  req.requestId = requestId

  console.log(`[${requestId}] ${req.method} ${req.originalUrl}`)

  res.on('finish', () => {
    const durationMs = Date.now() - start
    console.log(`[${requestId}] ${res.statusCode} ${req.method} ${req.originalUrl} (${durationMs}ms)`)
  })

  next()
})

app.use('/api/passage', passagesRoutes)
app.use('/api/dashboard', dashboardRoutes)
app.use('/api/public', publicRoutes)
app.use('/api/login', loginRoutes)
app.use('/api/admin', adminRoutes)

const toNumber = (value, fallback) => {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : fallback
}

/* ================= SSH TUNNEL (OPTIONNEL) ================= */
const sshTunnelEnabled = process.env.SSH_TUNNEL_ENABLED === 'true'
const sshTunnelHost = process.env.SSH_TUNNEL_HOST || 'comptage-db'
const sshTunnelUseConfig = process.env.SSH_TUNNEL_USE_CONFIG !== 'false'
const sshTunnelLocalPort = toNumber(process.env.SSH_TUNNEL_LOCAL_PORT, 5432)
const sshTunnelRemoteHost = process.env.SSH_TUNNEL_REMOTE_HOST || '127.0.0.1'
const sshTunnelRemotePort = toNumber(process.env.SSH_TUNNEL_REMOTE_PORT, 5432)
const sshTunnelReconnectMs = toNumber(process.env.SSH_TUNNEL_RECONNECT_MS, 3000)
const sshTunnelPassword = process.env.SSH_TUNNEL_PASSWORD || ''

let sshTunnelProcess = null
let sshReconnectTimer = null
let shutdownRequested = false

const startSshTunnel = () => {
  if (!sshTunnelEnabled) return
  if (sshTunnelProcess) return

  const args = sshTunnelUseConfig
    ? ['-N', sshTunnelHost]
    : [
        '-N',
        '-L',
        `${sshTunnelLocalPort}:${sshTunnelRemoteHost}:${sshTunnelRemotePort}`,
        sshTunnelHost
      ]

  console.log('Ouverture tunnel SSH...', sshTunnelHost)

  if (sshTunnelPassword) {
    sshTunnelProcess = spawn('sshpass', ['-p', sshTunnelPassword, 'ssh', ...args], {
      stdio: 'inherit'
    })
  } else {
    sshTunnelProcess = spawn('ssh', args, { stdio: 'inherit' })
  }

  sshTunnelProcess.on('error', (err) => {
    if (err.code === 'ENOENT' && sshTunnelPassword) {
      console.error('sshpass est requis pour utiliser SSH_TUNNEL_PASSWORD.')
      console.error('Installe-le puis relance l’API : sudo apt install sshpass')
      return
    }
    console.error('Tunnel SSH erreur', err.message)
  })

  sshTunnelProcess.on('exit', (code, signal) => {
    sshTunnelProcess = null
    if (shutdownRequested) return

    console.warn('Tunnel SSH fermé', { code, signal })

    if (sshReconnectTimer) return
    sshReconnectTimer = setTimeout(() => {
      sshReconnectTimer = null
      startSshTunnel()
    }, sshTunnelReconnectMs)
  })
}

const stopSshTunnel = () => {
  shutdownRequested = true
  if (sshReconnectTimer) clearTimeout(sshReconnectTimer)
  if (sshTunnelProcess && !sshTunnelProcess.killed) {
    sshTunnelProcess.kill('SIGTERM')
  }
}

const port = Number(process.env.PORT) || 3001
const server = http.createServer(app)

const io = new SocketIOServer(server, {
  cors: {
    origin: corsOrigins.length ? corsOrigins : true
  }
})

// Cache last events so new clients get immediate state.
const relayCache = {
  init: null,
  status: null,
  config: null,
  passage: null
}

io.on('connection', (socket) => {
  console.log('Client frontend connecté', socket.id)

  if (relayCache.init) socket.emit('init', relayCache.init)
  if (relayCache.status) socket.emit('status', relayCache.status)
  if (relayCache.config) socket.emit('config', relayCache.config)
  if (relayCache.passage) socket.emit('passage', relayCache.passage)

  socket.on('disconnect', (reason) => {
    console.log('Client frontend déconnecté', socket.id, reason)
  })
})

const sourceSocketUrl = process.env.SOURCE_SOCKET_URL || 'http://178.32.107.35:3000'
const sourceSocket = ioClient(sourceSocketUrl, {
  transports: ['websocket', 'polling'],
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionDelayMax: 5000
})

sourceSocket.on('connect', () => {
  console.log('Relais connecté à la VPS', sourceSocketUrl)
})

sourceSocket.on('connect_error', (err) => {
  console.error('Relais socket VPS erreur', err.message)
})

sourceSocket.on('disconnect', (reason) => {
  console.warn('Relais socket VPS déconnecté', reason)
})

const forwardEvent = (eventName) => {
  sourceSocket.on(eventName, (payload) => {
    relayCache[eventName] = payload
    if (eventName !== 'status') {
      console.log(`Relais event "${eventName}"`)
    }
    io.emit(eventName, payload)
  })
}

forwardEvent('init')
forwardEvent('passage')
forwardEvent('status')
forwardEvent('config')

let isShuttingDown = false

const shutdown = (signal) => {
  if (isShuttingDown) return
  isShuttingDown = true

  console.log(`Arrêt API (${signal})`)
  stopSshTunnel()

  try {
    sourceSocket?.close()
  } catch {}

  try {
    io.close()
  } catch {}

  server.close(() => {
    console.log('Serveur HTTP arrêté')
    process.exit(0)
  })

  setTimeout(() => {
    console.warn('Arrêt forcé après délai')
    process.exit(1)
  }, 5000)
}

process.on('SIGINT', () => shutdown('SIGINT'))
process.on('SIGTERM', () => shutdown('SIGTERM'))

server.listen(port, () => {
  console.log('API démarrée sur le port', port)
  console.log('Relais socket sur', sourceSocketUrl)
  startSshTunnel()
})
