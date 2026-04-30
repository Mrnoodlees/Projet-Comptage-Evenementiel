import express from 'express'
import { pool } from '../db.js'
import { ensureDoorSettingsTable } from '../doorSettings.js'

const router = express.Router()

const DEFAULT_MAX_PEOPLE = 100
const DEFAULT_BATTERY = 100
const TYPE_ENTREE = 'ENTREE'
const TYPE_SORTIE = 'SORTIE'
const TYPE_FIN = 'FIN'

// Cache de découverte BDD : évite de redemander les tables/colonnes à chaque requête.
const tableCache = {
  passageSource: null,
  hasAppareils: false
}

let settingsEnsured = false

const ensureSettingsTable = async () => {
  // Table simple pour conserver la capacité maximale configurée par l’admin.
  if (settingsEnsured) return
  await pool.query(`
    CREATE TABLE IF NOT EXISTS dashboard_settings (
      id integer PRIMARY KEY,
      max_people integer NOT NULL,
      updated_at timestamp without time zone DEFAULT NOW()
    )
  `)
  settingsEnsured = true
}

const getMaxPeople = async () => {
  // Retourne la capacité enregistrée ou une valeur par défaut.
  await ensureSettingsTable()
  const { rows } = await pool.query(`
    SELECT max_people
    FROM dashboard_settings
    WHERE id = 1
    LIMIT 1
  `)
  if (!rows.length) return DEFAULT_MAX_PEOPLE
  const value = Number(rows[0].max_people)
  return Number.isFinite(value) ? value : DEFAULT_MAX_PEOPLE
}

const setMaxPeople = async (value) => {
  // Upsert sur id=1 : il n’existe qu’un réglage global de capacité.
  await ensureSettingsTable()
  await pool.query(`
    INSERT INTO dashboard_settings (id, max_people, updated_at)
    VALUES (1, $1, NOW())
    ON CONFLICT (id)
    DO UPDATE SET max_people = EXCLUDED.max_people, updated_at = NOW()
  `, [value])
}

const resolveDoorColumn = (columnSet) => {
  // Les différentes versions de BDD peuvent nommer la porte différemment.
  if (columnSet.has('appareil_id')) return 'appareil_id'
  if (columnSet.has('capteur_id')) return 'capteur_id'
  if (columnSet.has('capteur')) return 'capteur'
  if (columnSet.has('id')) return 'id'
  return null
}

const resolvePassageSource = async () => {
  // Détecte automatiquement quelle table contient les passages.
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
    // Ancien schéma possible : table singulière passage.
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
    // Autre schéma possible : table plurielle passages.
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
    // Schéma capteur détaillé : plusieurs phases, on garde uniquement FIN.
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
  // Combine les filtres techniques avec la condition métier de la requête.
  if (!extraWhere) return `WHERE ${clause}`
  return `WHERE ${extraWhere} AND ${clause}`
}

const countByType = async (source, type) => {
  // Compte les entrées ou sorties dans la table détectée.
  const whereClause = buildWhereClause(source.extraWhere, `${source.typeColumn} = '${type}'`)
  const { rows } = await pool.query(`SELECT COUNT(*) FROM ${source.table} ${whereClause}`)
  return Number(rows[0]?.count || 0)
}

// Aggregate PMR counts based on doors marked in door_settings.
const getPmrSummary = async (source) => {
  // Agrège seulement les portes marquées PMR dans door_settings.
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
  // Batterie globale du dashboard = moyenne des batteries des appareils.
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
  // Route principale du dashboard : renvoie tout l’état courant en une réponse.
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] Dashboard state: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const [entries, exits, battery, pmr, maxPeople] = await Promise.all([
      countByType(source, TYPE_ENTREE),
      countByType(source, TYPE_SORTIE),
      getAverageBattery(),
      getPmrSummary(source),
      getMaxPeople()
    ])

    const people = entries - exits
    console.log(`[${requestId}] Dashboard state entries=${entries} exits=${exits} people=${people}`)

    return res.json({
      people,
      entries,
      exits,
      battery,
      maxPeople,
      pmrPeople: pmr.people
    })
  } catch (err) {
    console.error(`[${requestId}] Dashboard state erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= MAX PEOPLE ================= */
router.get('/max-people', async (req, res) => {
  // Lecture séparée de la capacité maximale.
  const requestId = req.requestId || 'no-id'
  try {
    const maxPeople = await getMaxPeople()
    return res.json({ maxPeople })
  } catch (err) {
    console.error(`[${requestId}] Max people erreur`, err.message)
    return res.sendStatus(500)
  }
})

router.post('/max-people', async (req, res) => {
  // Sauvegarde d’une nouvelle capacité depuis le panneau admin.
  const requestId = req.requestId || 'no-id'
  const value = Number(req.body?.maxPeople)

  if (!Number.isFinite(value) || value <= 0) {
    return res.status(400).json({ message: 'maxPeople invalide' })
  }

  try {
    await setMaxPeople(Math.floor(value))
    return res.json({ ok: true })
  } catch (err) {
    console.error(`[${requestId}] Max people update erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= COURBE PEOPLE ================= */
router.get('/people-chart', async (req, res) => {
  // Renvoie l’évolution cumulée des personnes présentes pour Chart.js.
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] People chart: aucune table`)
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

    console.log(`[${requestId}] People chart rows=${rows.length}`)
    return res.json(rows)
  } catch (err) {
    console.error(`[${requestId}] People chart erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= PORTES ================= */
router.get('/door-stats', async (req, res) => {
  // Statistiques par porte : entrées, sorties, présents, batterie, flag PMR.
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] Door stats: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    if (!source.doorColumn) {
      console.warn(`[${requestId}] Door stats: aucune colonne porte`)
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

    console.log(`[${requestId}] Door stats doors=${rows.length}`)
    return res.json({ doors: rows, pmr })
  } catch (err) {
    console.error(`[${requestId}] Door stats erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= PMR SUMMARY ================= */
router.get('/pmr', async (req, res) => {
  // Résumé PMR isolé si un écran veut seulement cette information.
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] PMR: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const pmr = await getPmrSummary(source)
    console.log(`[${requestId}] PMR entries=${pmr.entries} exits=${pmr.exits} people=${pmr.people}`)
    return res.json(pmr)
  } catch (err) {
    console.error(`[${requestId}] PMR erreur`, err.message)
    return res.sendStatus(500)
  }
})

/* ================= INFLUENCE ================= */
router.get('/influence', async (req, res) => {
  // Ancienne route d’influence : compte les entrées groupées par heure.
  const requestId = req.requestId || 'no-id'
  try {
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] Influence: aucune table`)
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

    console.log(`[${requestId}] Influence rows=${rows.length}`)
    return res.json(rows)
  } catch (err) {
    console.error(`[${requestId}] Influence erreur`, err.message)
    return res.sendStatus(500)
  }
})

export default router
