import express from 'express'
import { verifyQrToken, resetQrTokens } from '../qrTokens.js'
import { bumpAccessVersion, getAccessVersion } from '../qrAccessVersion.js'

const router = express.Router()

// Routes historiques pour l’accès QR du dashboard.
// Elles doublonnent en partie /api/admin/verify, mais restent utiles si le front les appelle.
const shouldRevokeQrTokens = () => process.env.QR_RESET_REVOKE !== 'false'

router.get('/verify', async (req, res) => {
  // Vérifie un token QR admin depuis une URL publique.
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
  // Version d’accès courante pour invalider les anciennes sessions QR.
  return res.json({ version: getAccessVersion() })
})

router.post('/reset', async (_req, res) => {
  // Reset manuel des accès QR liés à cette route.
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
