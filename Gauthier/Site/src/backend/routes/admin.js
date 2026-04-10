import express from 'express'
import { pool } from '../db.js'
import { upsertDoorSetting } from '../doorSettings.js'
import { createQrToken, verifyQrToken, resetQrTokens, listQrTokens } from '../qrTokens.js'
import { bumpAccessVersion, getAccessVersion } from '../qrAccessVersion.js'

const router = express.Router()

const shouldRevokeQrTokens = () => process.env.QR_RESET_REVOKE !== 'false'

router.post('/qr', async (_req, res) => {
  try {
    const token = await createQrToken('admin')
    return res.json({ token, expiresAt: null })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de générer le QR.' })
  }
})

router.get('/qr-tokens', async (_req, res) => {
  try {
    const tokens = await listQrTokens('admin')
    return res.json({ count: tokens.length })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de lire les tokens.' })
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
    // Même si le reset DB échoue, on invalide les sessions locales
  }
  return res.json({ version: getAccessVersion() })
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
    return res.json({ ok: true, version: getAccessVersion() })
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

router.get('/appareils', async (_req, res) => {
  try {
    const { rows } = await pool.query(`
      SELECT
        id,
        batterie,
        sensibilite,
        frequence,
        role_f,
        role_b,
        timestamp,
        derniere_vu,
        temps_bloque
      FROM appareils
      ORDER BY id
    `)
    return res.json(rows)
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de charger les appareils.' })
  }
})

router.patch('/appareils/:id', async (req, res) => {
  const { id } = req.params
  const allowed = ['sensibilite', 'role_f', 'role_b', 'temps_bloque']
  const updates = []
  const values = []

  allowed.forEach((key) => {
    if (req.body[key] === undefined) return
    let value = req.body[key]
    if (value === '') value = null
    updates.push(`${key} = $${values.length + 1}`)
    values.push(value)
  })

  if (updates.length === 0) {
    return res.status(400).json({ message: 'Aucune valeur à mettre à jour.' })
  }

  values.push(id)

  try {
    await pool.query(
      `UPDATE appareils SET ${updates.join(', ')} WHERE id = $${values.length}`,
      values
    )
    return res.json({ ok: true })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de mettre à jour l’appareil.' })
  }
})

router.delete('/appareils/:id', async (req, res) => {
  const { id } = req.params

  if (!id) {
    return res.status(400).json({ message: 'id manquant' })
  }

  try {
    const result = await pool.query(
      'DELETE FROM appareils WHERE id = $1',
      [id]
    )
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Appareil introuvable' })
    }
    return res.json({ ok: true })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de supprimer l’appareil.' })
  }
})

export default router
