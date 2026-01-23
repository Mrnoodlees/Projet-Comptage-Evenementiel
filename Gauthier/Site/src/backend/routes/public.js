import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

router.get('/influence', async (req, res) => {
  const { from, to } = req.query

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

  res.json(result.rows)
})

export default router
