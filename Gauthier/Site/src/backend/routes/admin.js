import express from 'express'
import { upsertDoorSetting } from '../doorSettings.js'
import { createQrToken, verifyQrToken, resetQrTokens } from '../qrTokens.js'

const router = express.Router()

let accessVersion = 1

router.post('/qr', async (_req, res) => {
  try {
    const token = await createQrToken('admin')
    return res.json({ token, expiresAt: null })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de générer le QR.' })
  }
})

router.get('/version', (_req, res) => {
  return res.json({ version: accessVersion })
})

router.post('/reset', async (_req, res) => {
  accessVersion += 1
  try {
    await resetQrTokens('admin')
  } catch {
    // Même si le reset DB échoue, on invalide les sessions locales
  }
  return res.json({ version: accessVersion })
})

router.get('/verify', async (req, res) => {
  const token = req.query.token

  if (!token || typeof token !== 'string') {
    return res.status(400).json({ message: 'Token manquant' })
  }

  try {
    const ok = await verifyQrToken('admin', token)
    if (!ok) {
      return res.status(401).json({ message: 'Token invalide' })
    }
    return res.json({ ok: true, version: accessVersion })
  } catch (err) {
    return res.status(500).json({ message: 'Erreur vérification token' })
  }
})

router.post('/door-pmr', async (req, res) => {
  const { doorId, isPmr } = req.body || {}

  if (!doorId || typeof doorId !== 'string') {
    return res.status(400).json({ message: 'doorId manquant' })
  }

  try {
    await upsertDoorSetting(doorId, Boolean(isPmr))
    return res.json({ ok: true })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de mettre à jour la porte.' })
  }
})

export default router
