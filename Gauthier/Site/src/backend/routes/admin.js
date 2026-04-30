import express from 'express'
import { pool } from '../db.js'
import { upsertDoorSetting } from '../doorSettings.js'
import { hashPassword } from '../auth.js'
import { createQrToken, verifyQrToken, resetQrTokens, listQrTokens } from '../qrTokens.js'
import { bumpAccessVersion, getAccessVersion } from '../qrAccessVersion.js'

const router = express.Router()

// Permet de choisir si le reset QR révoque aussi les tokens stockés en BDD.
const shouldRevokeQrTokens = () => process.env.QR_RESET_REVOKE !== 'false'

router.post('/qr', async (_req, res) => {
  // Génère un token QR persistant pour ouvrir le dashboard via lien scanné.
  try {
    const token = await createQrToken('admin')
    return res.json({ token, expiresAt: null })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de générer le QR.' })
  }
})

router.get('/qr-tokens', async (_req, res) => {
  // Route de diagnostic : donne le nombre de tokens admin encore actifs.
  try {
    const tokens = await listQrTokens('admin')
    return res.json({ count: tokens.length })
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de lire les tokens.' })
  }
})

router.get('/version', (_req, res) => {
  // Version utilisée par les navigateurs pour savoir si leur session QR est périmée.
  return res.json({ version: getAccessVersion() })
})

router.post('/reset', async (_req, res) => {
  // Invalide les sessions QR existantes et, selon la config, révoque les tokens BDD.
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
  // Vérifie un token reçu depuis l’URL /dashboard?admin_token=...
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
  // Marque une porte comme PMR ou non. Le dashboard peut ensuite agréger ces passages.
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

router.post('/users', async (req, res) => {
  // Création d’un compte de connexion depuis le panneau admin.
  const { username, password } = req.body || {}

  if (!username || !password) {
    return res.status(400).json({ message: 'Identifiants manquants' })
  }

  const normalizedUsername = String(username).trim()
  if (!normalizedUsername) {
    return res.status(400).json({ message: 'Utilisateur invalide' })
  }

  try {
    const existing = await pool.query(
      'SELECT id FROM login WHERE username = $1 LIMIT 1',
      [normalizedUsername]
    )
    if (existing.rows.length > 0) {
      return res.status(409).json({ message: 'Utilisateur déjà existant' })
    }

    const hashed = hashPassword(String(password))
    const insert = await pool.query(
      'INSERT INTO login (username, mdp) VALUES ($1, $2) RETURNING id, username',
      [normalizedUsername, hashed]
    )
    return res.status(201).json(insert.rows[0])
  } catch (err) {
    return res.status(500).json({ message: 'Impossible de créer l’utilisateur.' })
  }
})

router.get('/appareils', async (_req, res) => {
  // Liste les capteurs/appareils connus pour affichage et configuration.
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
  // Met à jour uniquement les champs autorisés pour éviter une modification libre SQL.
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
  // Supprime un capteur/appareil de la table appareils.
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
