import express from 'express'
import crypto from 'node:crypto'

const router = express.Router()

const tokens = new Map()
const ttlMs = Number(process.env.ADMIN_QR_TTL_MS) || 5 * 60 * 1000
let accessVersion = 1

const cleanup = () => {
  const now = Date.now()
  for (const [token, expiresAt] of tokens.entries()) {
    if (expiresAt <= now) {
      tokens.delete(token)
    }
  }
}

router.post('/qr', (req, res) => {
  cleanup()
  const token = crypto.randomUUID()
  const expiresAt = Date.now() + ttlMs
  tokens.set(token, expiresAt)

  return res.json({ token, expiresAt })
})

router.get('/version', (_req, res) => {
  cleanup()
  return res.json({ version: accessVersion })
})

router.post('/reset', (_req, res) => {
  cleanup()
  accessVersion += 1
  return res.json({ version: accessVersion })
})

router.get('/verify', (req, res) => {
  cleanup()
  const token = req.query.token

  if (!token || typeof token !== 'string') {
    return res.status(400).json({ message: 'Token manquant' })
  }

  const expiresAt = tokens.get(token)
  if (!expiresAt || expiresAt <= Date.now()) {
    return res.status(401).json({ message: 'Token invalide ou expiré' })
  }

  tokens.delete(token)
  return res.json({ ok: true, version: accessVersion })
})

export default router
