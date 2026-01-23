import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

/* ================= ETAT DASHBOARD ================= */
router.get('/state', async (req, res) => {
  const [{ rows: entries }] = await Promise.all([
    pool.query(`SELECT COUNT(*) FROM passages WHERE type = 'ENTREE'`),
  ])

  const [{ rows: exits }] = await Promise.all([
    pool.query(`SELECT COUNT(*) FROM passages WHERE type = 'SORTIE'`)
  ])

  const people = entries[0].count - exits[0].count

  res.json({
    people: Number(people),
    entries: Number(entries[0].count),
    exits: Number(exits[0].count),
    battery: 100,
    maxPeople: 100
  })
})

/* ================= COURBE PEOPLE ================= */
router.get('/people-chart', async (req, res) => {
  const { rows } = await pool.query(`
    SELECT date_heure, 
           SUM(CASE WHEN type='ENTREE' THEN 1 ELSE -1 END)
           OVER (ORDER BY date_heure) AS people
    FROM passages
    ORDER BY date_heure
  `)

  res.json(rows)
})

/* ================= INFLUENCE ================= */
router.get('/influence', async (req, res) => {
  const { rows } = await pool.query(`
    SELECT
      to_char(date_trunc('hour', date_heure), 'HH24:00') AS hour,
      COUNT(*) AS count
    FROM passages
    WHERE type = 'ENTREE'
    GROUP BY hour
    ORDER BY hour
  `)

  res.json(rows)
})

export default router
