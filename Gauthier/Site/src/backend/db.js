import dotenv from 'dotenv'
import pkg from 'pg'

dotenv.config()
const { Pool } = pkg

const toNumber = (value, fallback) => {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : fallback
}

const getEnv = (key, fallback) => process.env[key] || fallback

// Switch DB host/port to local tunnel when enabled.
const sshTunnelEnabled = process.env.SSH_TUNNEL_ENABLED === 'true'
const tunnelLocalHost = process.env.SSH_TUNNEL_LOCAL_HOST || '127.0.0.1'
const tunnelLocalPort = toNumber(process.env.SSH_TUNNEL_LOCAL_PORT, 5432)

const dbConnectTimeoutMs = toNumber(process.env.DB_CONNECT_TIMEOUT_MS, 5000)
const dbQueryTimeoutMs = toNumber(process.env.DB_QUERY_TIMEOUT_MS, 10000)

const dbConfig = {
  host: getEnv('DB_HOST', '178.32.107.35'),
  user: getEnv('DB_USER', 'postgres'),
  password: getEnv('DB_PASSWORD', 'dot'),
  database: getEnv('DB_NAME', 'projet_ir'),
  port: toNumber(process.env.DB_PORT, 5432),
  connectionTimeoutMillis: dbConnectTimeoutMs,
  query_timeout: dbQueryTimeoutMs
}

if (sshTunnelEnabled) {
  dbConfig.host = tunnelLocalHost
  dbConfig.port = tunnelLocalPort
}

export const pool = new Pool(dbConfig)

const shouldLogQueries = process.env.LOG_SQL === 'true'
const shouldLogDbConfig = process.env.LOG_DB_CONFIG === 'true'

pool.on('error', (err) => {
  console.error('BDD erreur inattendue', err.message)
})

pool.on('connect', (client) => {
  const statementTimeoutMs = toNumber(process.env.DB_STATEMENT_TIMEOUT_MS, 10000)
  const lockTimeoutMs = toNumber(process.env.DB_LOCK_TIMEOUT_MS, 5000)
  client
    .query(`SET statement_timeout TO ${statementTimeoutMs}`)
    .catch((err) => console.error('BDD statement_timeout', err.message))
  client
    .query(`SET lock_timeout TO ${lockTimeoutMs}`)
    .catch((err) => console.error('BDD lock_timeout', err.message))
})

if (shouldLogDbConfig) {
  const mode = sshTunnelEnabled ? 'tunnel' : 'direct'
  console.log(
    `BDD (${mode}) -> host=${dbConfig.host} port=${dbConfig.port} db=${dbConfig.database} user=${dbConfig.user} connectTimeout=${dbConnectTimeoutMs}ms queryTimeout=${dbQueryTimeoutMs}ms`
  )
}

if (shouldLogQueries) {
  const originalQuery = pool.query.bind(pool)
  pool.query = async (...args) => {
    const startedAt = Date.now()
    const text = typeof args[0] === 'string' ? args[0] : '[query]'
    try {
      const result = await originalQuery(...args)
      const duration = Date.now() - startedAt
      console.log(`[SQL] ${duration}ms ${text.replace(/\s+/g, ' ').trim()}`)
      return result
    } catch (err) {
      const duration = Date.now() - startedAt
      console.error(`[SQL] ${duration}ms ${text.replace(/\s+/g, ' ').trim()}`)
      console.error('[SQL] erreur', err.message)
      throw err
    }
  }
}
