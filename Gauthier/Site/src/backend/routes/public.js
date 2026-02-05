import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

router.get('/influence', async (req, res) => {
  const { from, to } = req.query
  const requestId = req.requestId || 'no-id'

  if (!from || !to) {
    console.warn(`⚠️  [${requestId}] Public influence: from/to manquant`)
    return res.status(400).json({ message: 'Paramètres from/to manquants.' })
  }

  try {
    const result = await pool.query(`
      SELECT
        date_trunc('hour', ts) AS heure,
        COUNT(*) FILTER (WHERE mode_passage='ENTREE') AS entrees,
        COUNT(*) FILTER (WHERE mode_passage='SORTIE') AS sorties
      FROM log_passages
      WHERE
        type_passage='FIN'
        AND ts BETWEEN $1 AND $2
      GROUP BY heure
      ORDER BY heure
    `, [from, to])

    console.log(`🌍 [${requestId}] Public influence rows=${result.rows.length}`)
    return res.json(result.rows)
  } catch (err) {
    console.error(`❌ [${requestId}] Public influence erreur`, err.message)
    return res.status(500).json({ message: 'Erreur influence.' })
  }
})

export default router
