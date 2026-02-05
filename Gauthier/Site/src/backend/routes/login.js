import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

router.post('/', async (req, res) => {
  const { username, password } = req.body
  const requestId = req.requestId || 'no-id'

  if (!username || !password) {
    console.warn(`⚠️  [${requestId}] Login manquant`)
    return res.status(400).json({ message: 'Identifiants manquants' })
  }

  try {
    console.log(`🔐 [${requestId}] Tentative login user="${username}"`)
    const { rows } = await pool.query(
      `
        SELECT id, username
        FROM login
        WHERE username = $1 AND mdp = $2
        LIMIT 1
      `,
      [username, password]
    )

    if (rows.length === 0) {
      console.warn(`❌ [${requestId}] Login refusé user="${username}"`)
      return res.status(401).json({ message: 'Identifiants incorrects' })
    }

    console.log(`✅ [${requestId}] Login OK user="${username}"`)
    return res.json({ id: rows[0].id, username: rows[0].username })
  } catch (err) {
    console.error(`❌ [${requestId}] Erreur login`, err.message)
    return res.status(500).json({ message: 'Connexion impossible pour le moment.' })
  }
})

export default router
