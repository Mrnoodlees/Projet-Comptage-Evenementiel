import express from 'express'
import { pool } from '../db.js'
import { hashPassword, verifyPassword, isHashedPassword } from '../auth.js'

const router = express.Router()

router.post('/', async (req, res) => {
  // Route appelée par Login.vue pour ouvrir le dashboard privé.
  const { username, password } = req.body
  const requestId = req.requestId || 'no-id'

  if (!username || !password) {
    console.warn(`[${requestId}] Login manquant`)
    return res.status(400).json({ message: 'Identifiants manquants' })
  }

  try {
    const normalizedUsername = String(username).trim()
    // Auth check against the login table.
    console.log(`[${requestId}] Tentative login user="${normalizedUsername}"`)
    const { rows } = await pool.query(
      `
        SELECT id, username, mdp
        FROM login
        WHERE username = $1
        LIMIT 1
      `,
      [normalizedUsername]
    )

    if (rows.length === 0) {
      console.warn(`[${requestId}] Login refusé user="${username}"`)
      return res.status(401).json({ message: 'Identifiants incorrects' })
    }

    const user = rows[0]
    // verifyPassword accepte les anciens mots de passe en clair et les nouveaux hashés.
    const ok = verifyPassword(password, user.mdp)
    if (!ok) {
      console.warn(`[${requestId}] Login refusé user="${normalizedUsername}"`)
      return res.status(401).json({ message: 'Identifiants incorrects' })
    }

    if (!isHashedPassword(user.mdp)) {
      // Migration transparente : dès qu’un ancien compte se connecte, on hash son mdp.
      try {
        const upgraded = hashPassword(password)
        await pool.query('UPDATE login SET mdp = $1 WHERE id = $2', [upgraded, user.id])
      } catch {
        // If upgrade fails, keep login valid.
      }
    }

    console.log(`[${requestId}] Login OK user="${normalizedUsername}"`)
    return res.json({ id: user.id, username: user.username })
  } catch (err) {
    console.error(`[${requestId}] Erreur login`, err.message)
    return res.status(500).json({ message: 'Connexion impossible pour le moment.' })
  }
})

export default router
