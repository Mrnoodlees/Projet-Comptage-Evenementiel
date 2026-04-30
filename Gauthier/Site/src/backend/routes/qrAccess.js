import express from 'express'
import { verifyQrToken, resetQrTokens } from '../qrTokens.js'
import { bumpAccessVersion, getAccessVersion } from '../qrAccessVersion.js'

const router = express.Router()

const shouldRevokeQrTokens = () => process.env.QR_RESET_REVOKE !== 'false'

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
    return res.json({ ok: true, version: getAccessVersion() })
  } catch (err) {
    return res.status(500).json({ message: 'Erreur vérification token' })
  }
})

router.get('/version', (_req, res) => {
  return res.json({ version: getAccessVersion() })
})

router.post('/reset', async (_req, res) => {
  bumpAccessVersion()
  try {
    if (shouldRevokeQrTokens()) {
      await resetQrTokens('admin')
    }
  } catch {
    // ignore reset errors
  }
  return res.json({ version: getAccessVersion() })
})

export default router
