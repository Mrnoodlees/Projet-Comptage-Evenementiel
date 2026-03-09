import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

/**
 * Enregistrement d’un passage (depuis capteur / MQTT)
 */
router.post('/', async (req, res) => {
  const {
    capteur_id,
    capteur,
    mode_passage // ENTREE | SORTIE
  } = req.body
  const requestId = req.requestId || 'no-id'

  try {
    console.log(`[${requestId}] POST /api/passage capteur_id=${capteur_id} mode=${mode_passage}`)
    await pool.query(`
      INSERT INTO log_passages
        (capteur_id, capteur, type_passage, mode_passage, ts)
      VALUES
        ($1, $2, 'FIN', $3, NOW())
    `, [capteur_id, capteur, mode_passage])

    return res.sendStatus(201)
  } catch (err) {
    console.error(`[${requestId}] Erreur insertion passage`, err.message)
    return res.sendStatus(500)
  }
})

/**
 * Historique brut (admin)
 */
router.get('/', async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 500, 1000)
  const requestId = req.requestId || 'no-id'

  try {
    console.log(`[${requestId}] GET /api/passage limit=${limit}`)
    const result = await pool.query(`
      SELECT *
      FROM log_passages
      ORDER BY ts DESC
      LIMIT $1
    `, [limit])

    return res.json(result.rows)
  } catch (err) {
    console.error(`[${requestId}] Erreur lecture passages`, err.message)
    return res.status(500).json({ message: 'Impossible de récupérer les passages.' })
  }
})

export default router
