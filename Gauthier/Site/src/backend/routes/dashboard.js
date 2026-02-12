import express from 'express'
import { pool } from '../db.js'
import { ensureDoorSettingsTable } from '../doorSettings.js'

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

const resolveDoorColumn = (columnSet) => {
  if (columnSet.has('appareil_id')) return 'appareil_id'
  if (columnSet.has('capteur_id')) return 'capteur_id'
  if (columnSet.has('capteur')) return 'capteur'
  if (columnSet.has('id')) return 'id'
  return null
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
    const columns = await pool.query(`
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'passage'
    `)
    const columnSet = new Set(columns.rows.map(rowItem => rowItem.column_name))
    const dateColumn = columnSet.has('date_heure')
      ? 'date_heure'
      : columnSet.has('timestamp')
        ? 'timestamp'
        : 'date_heure'

    tableCache.passageSource = {
      table: 'passage',
      typeColumn: 'type',
      dateColumn,
      extraWhere: '',
      doorColumn: resolveDoorColumn(columnSet)
    }
    return tableCache.passageSource
  }

  if (row.passages) {
    const columns = await pool.query(`
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'passages'
    `)
    const columnSet = new Set(columns.rows.map(rowItem => rowItem.column_name))
    const dateColumn = columnSet.has('date_heure')
      ? 'date_heure'
      : columnSet.has('timestamp')
        ? 'timestamp'
        : 'date_heure'

    tableCache.passageSource = {
      table: 'passages',
      typeColumn: 'type',
      dateColumn,
      extraWhere: '',
      doorColumn: resolveDoorColumn(columnSet)
    }
    return tableCache.passageSource
  }

  if (row.log_passages) {
    const columns = await pool.query(`
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'log_passages'
    `)
    const columnSet = new Set(columns.rows.map(rowItem => rowItem.column_name))

    tableCache.passageSource = {
      table: 'log_passages',
      typeColumn: 'mode_passage',
      dateColumn: 'ts',
      extraWhere: `type_passage = '${TYPE_FIN}'`,
      doorColumn: resolveDoorColumn(columnSet)
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

const getPmrSummary = async (source) => {
  if (!source.doorColumn) {
    return { entries: 0, exits: 0, people: 0 }
  }

  await ensureDoorSettingsTable()
  const whereClause = source.extraWhere ? `WHERE ${source.extraWhere}` : ''

  const { rows } = await pool.query(`
    WITH stats AS (
      SELECT
        ${source.doorColumn} AS door,
        SUM(CASE WHEN ${source.typeColumn}='${TYPE_ENTREE}' THEN 1 ELSE 0 END)::int AS entries,
        SUM(CASE WHEN ${source.typeColumn}='${TYPE_SORTIE}' THEN 1 ELSE 0 END)::int AS exits
      FROM ${source.table}
      ${whereClause}
      GROUP BY ${source.doorColumn}
    )
    SELECT
      COALESCE(SUM(stats.entries), 0)::int AS entries,
      COALESCE(SUM(stats.exits), 0)::int AS exits
    FROM stats
    JOIN door_settings ds ON ds.door_id = stats.door
    WHERE ds.is_pmr = true
  `)

  const entries = Number(rows[0]?.entries || 0)
  const exits = Number(rows[0]?.exits || 0)
  return { entries, exits, people: entries - exits }
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

    const [entries, exits, battery, pmr] = await Promise.all([
      countByType(source, TYPE_ENTREE),
      countByType(source, TYPE_SORTIE),
      getAverageBattery(),
      getPmrSummary(source)
    ])

    const people = entries - exits
    console.log(`📊 [${requestId}] Dashboard state entries=${entries} exits=${exits} people=${people}`)

    return res.json({
      people,
      entries,
      exits,
      battery,
      maxPeople: DEFAULT_MAX_PEOPLE,
      pmrPeople: pmr.people
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

/* ================= PORTES ================= */
router.get('/door-stats', async (req, res) => {
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`⚠️  [${requestId}] Door stats: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    if (!source.doorColumn) {
      console.warn(`⚠️  [${requestId}] Door stats: aucune colonne porte`)
      return res.status(500).json({ message: 'Aucune colonne de porte trouvée.' })
    }

    await ensureDoorSettingsTable()

    const whereClause = source.extraWhere ? `WHERE ${source.extraWhere}` : ''
    const joinAppareils = tableCache.hasAppareils
      ? 'LEFT JOIN appareils a ON a.id = stats.door'
      : ''
    const selectBattery = tableCache.hasAppareils
      ? 'a.batterie AS battery, a.derniere_vu AS last_seen,'
      : 'NULL::int AS battery, NULL::timestamp AS last_seen,'

    const { rows } = await pool.query(`
      WITH stats AS (
        SELECT
          ${source.doorColumn} AS door,
          SUM(CASE WHEN ${source.typeColumn}='${TYPE_ENTREE}' THEN 1 ELSE 0 END)::int AS entries,
          SUM(CASE WHEN ${source.typeColumn}='${TYPE_SORTIE}' THEN 1 ELSE 0 END)::int AS exits
        FROM ${source.table}
        ${whereClause}
        GROUP BY ${source.doorColumn}
      )
      SELECT
        stats.door,
        stats.entries,
        stats.exits,
        (stats.entries - stats.exits) AS people,
        ${selectBattery}
        COALESCE(ds.is_pmr, false) AS is_pmr
      FROM stats
      LEFT JOIN door_settings ds ON ds.door_id = stats.door
      ${joinAppareils}
      ORDER BY stats.door
    `)

    const pmr = rows.reduce(
      (acc, row) => {
        if (!row.is_pmr) return acc
        acc.entries += Number(row.entries || 0)
        acc.exits += Number(row.exits || 0)
        acc.people = acc.entries - acc.exits
        return acc
      },
      { entries: 0, exits: 0, people: 0 }
    )

    console.log(`🚪 [${requestId}] Door stats doors=${rows.length}`)
    return res.json({ doors: rows, pmr })
  } catch (err) {
    console.error(`❌ [${requestId}] Door stats erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= PMR SUMMARY ================= */
router.get('/pmr', async (req, res) => {
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`⚠️  [${requestId}] PMR: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const pmr = await getPmrSummary(source)
    console.log(`♿ [${requestId}] PMR entries=${pmr.entries} exits=${pmr.exits} people=${pmr.people}`)
    return res.json(pmr)
  } catch (err) {
    console.error(`❌ [${requestId}] PMR erreur`, err.message)
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
