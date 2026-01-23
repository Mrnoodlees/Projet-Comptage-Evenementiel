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

  try {
    await pool.query(`
      INSERT INTO log_passages
        (capteur_id, capteur, type_passage, mode_passage, ts)
      VALUES
        ($1, $2, 'FIN', $3, NOW())
    `, [capteur_id, capteur, mode_passage])

    res.sendStatus(201)
  } catch (err) {
    console.error(err)
    res.sendStatus(500)
  }
})

/**
 * Historique brut (admin)
 */
router.get('/', async (_req, res) => {
  const result = await pool.query(`
    SELECT *
    FROM log_passages
    ORDER BY ts DESC
    LIMIT 500
  `)

  res.json(result.rows)
})

export default router
