import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

const DEFAULT_MAX_PEOPLE = 100
const DEFAULT_BATTERY = 100
const TYPE_ENTREE = 'ENTREE'
const TYPE_SORTIE = 'SORTIE'
const TYPE_FIN = 'FIN'

const tableCache = {
  passageSource: null,
  hasAppareils: false
}

const resolvePassageSource = async () => {
  if (tableCache.passageSource) return tableCache.passageSource

  const { rows } = await pool.query(`
    SELECT
      to_regclass('public.passage') AS passage,
      to_regclass('public.passages') AS passages,
      to_regclass('public.log_passages') AS log_passages,
      to_regclass('public.appareils') AS appareils
  `)

  const row = rows[0] || {}
  tableCache.hasAppareils = Boolean(row.appareils)

  if (row.passage) {
    tableCache.passageSource = {
      table: 'passage',
      typeColumn: 'type',
      dateColumn: 'date_heure',
      extraWhere: ''
    }
    return tableCache.passageSource
  }

  if (row.passages) {
    tableCache.passageSource = {
      table: 'passages',
      typeColumn: 'type',
      dateColumn: 'date_heure',
      extraWhere: ''
    }
    return tableCache.passageSource
  }

  if (row.log_passages) {
    tableCache.passageSource = {
      table: 'log_passages',
      typeColumn: 'mode_passage',
      dateColumn: 'ts',
      extraWhere: `type_passage = '${TYPE_FIN}'`
    }
    return tableCache.passageSource
  }

  return null
}

const buildWhereClause = (extraWhere, clause) => {
  if (!extraWhere) return `WHERE ${clause}`
  return `WHERE ${extraWhere} AND ${clause}`
}

const countByType = async (source, type) => {
  const whereClause = buildWhereClause(source.extraWhere, `${source.typeColumn} = '${type}'`)
  const { rows } = await pool.query(`SELECT COUNT(*) FROM ${source.table} ${whereClause}`)
  return Number(rows[0]?.count || 0)
}

const getAverageBattery = async () => {
  if (!tableCache.hasAppareils) return DEFAULT_BATTERY

  const { rows } = await pool.query(`
    SELECT AVG(batterie)::int AS battery
    FROM appareils
  `)

  const average = rows[0]?.battery
  return average === null || average === undefined ? DEFAULT_BATTERY : Number(average)
}

/* ================= ETAT DASHBOARD ================= */
router.get('/state', async (req, res) => {
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`⚠️  [${requestId}] Dashboard state: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const [entries, exits, battery] = await Promise.all([
      countByType(source, TYPE_ENTREE),
      countByType(source, TYPE_SORTIE),
      getAverageBattery()
    ])

    const people = entries - exits
    console.log(`📊 [${requestId}] Dashboard state entries=${entries} exits=${exits} people=${people}`)

    return res.json({
      people,
      entries,
      exits,
      battery,
      maxPeople: DEFAULT_MAX_PEOPLE
    })
  } catch (err) {
    console.error(`❌ [${requestId}] Dashboard state erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= COURBE PEOPLE ================= */
router.get('/people-chart', async (req, res) => {
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`⚠️  [${requestId}] People chart: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const whereClause = source.extraWhere ? `WHERE ${source.extraWhere}` : ''
    const { rows } = await pool.query(`
      SELECT ${source.dateColumn} AS date_heure,
             SUM(CASE WHEN ${source.typeColumn}='${TYPE_ENTREE}' THEN 1 ELSE -1 END)
             OVER (ORDER BY ${source.dateColumn}) AS people
      FROM ${source.table}
      ${whereClause}
      ORDER BY ${source.dateColumn}
    `)

    console.log(`📈 [${requestId}] People chart rows=${rows.length}`)
    return res.json(rows)
  } catch (err) {
    console.error(`❌ [${requestId}] People chart erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= INFLUENCE ================= */
router.get('/influence', async (req, res) => {
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`⚠️  [${requestId}] Influence: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const whereClause = buildWhereClause(source.extraWhere, `${source.typeColumn} = '${TYPE_ENTREE}'`)
    const { rows } = await pool.query(`
      SELECT
        to_char(date_trunc('hour', ${source.dateColumn}), 'HH24:00') AS hour,
        COUNT(*) AS count
      FROM ${source.table}
      ${whereClause}
      GROUP BY hour
      ORDER BY hour
    `)

    console.log(`📊 [${requestId}] Influence rows=${rows.length}`)
    return res.json(rows)
  } catch (err) {
    console.error(`❌ [${requestId}] Influence erreur`, err.message)
    return res.sendStatus(500)
  }
})

export default router
