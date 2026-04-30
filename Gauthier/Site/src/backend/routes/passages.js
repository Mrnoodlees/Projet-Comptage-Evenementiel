import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

const getColumns = async (schemaName, tableName) => {
  const { rows } = await pool.query(
    `
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = $1 AND table_name = $2
    `,
    [schemaName, tableName]
  )
  return new Set(rows.map(row => row.column_name))
}

const findTable = async (tableName) => {
  const preferredSchema = process.env.DB_SCHEMA || 'public'
  const { rows } = await pool.query(
    `
      SELECT table_schema
      FROM information_schema.tables
      WHERE table_name = $1
      ORDER BY CASE WHEN table_schema = $2 THEN 0 ELSE 1 END, table_schema
      LIMIT 1
    `,
    [tableName, preferredSchema]
  )

  if (!rows.length) return null
  return { schema: rows[0].table_schema, table: tableName }
}

const resolvePassageSource = async () => {
  const logPassages = await findTable('log_passages')
  const passages = await findTable('passages')
  const passage = await findTable('passage')

  if (logPassages) {
    const columns = await getColumns(logPassages.schema, logPassages.table)
    const dateColumn = columns.has('ts')
      ? 'ts'
      : columns.has('date_heure')
        ? 'date_heure'
        : columns.has('timestamp')
          ? 'timestamp'
          : null
    const typeColumn = columns.has('mode_passage') ? 'mode_passage' : columns.has('type') ? 'type' : null
    const idColumn = columns.has('appareil_id')
      ? 'appareil_id'
      : columns.has('capteur_id')
        ? 'capteur_id'
        : columns.has('capteur')
          ? 'capteur'
          : null
    const extraWhere = columns.has('type_passage') ? "type_passage='FIN'" : ''

    if (dateColumn && typeColumn) {
      return { ...logPassages, dateColumn, typeColumn, idColumn, extraWhere }
    }
  }

  if (passages) {
    const columns = await getColumns(passages.schema, passages.table)
    const dateColumn = columns.has('date_heure')
      ? 'date_heure'
      : columns.has('timestamp')
        ? 'timestamp'
        : null
    const typeColumn = columns.has('type') ? 'type' : columns.has('mode_passage') ? 'mode_passage' : null
    const idColumn = columns.has('appareil_id')
      ? 'appareil_id'
      : columns.has('capteur_id')
        ? 'capteur_id'
        : columns.has('capteur')
          ? 'capteur'
          : null

    if (dateColumn && typeColumn) {
      return { ...passages, dateColumn, typeColumn, idColumn, extraWhere: '' }
    }
  }

  if (passage) {
    const columns = await getColumns(passage.schema, passage.table)
    const dateColumn = columns.has('date_heure')
      ? 'date_heure'
      : columns.has('timestamp')
        ? 'timestamp'
        : null
    const typeColumn = columns.has('type') ? 'type' : columns.has('mode_passage') ? 'mode_passage' : null
    const idColumn = columns.has('appareil_id')
      ? 'appareil_id'
      : columns.has('capteur_id')
        ? 'capteur_id'
        : columns.has('capteur')
          ? 'capteur'
          : null

    if (dateColumn && typeColumn) {
      return { ...passage, dateColumn, typeColumn, idColumn, extraWhere: '' }
    }
  }

  return null
}

const buildWhere = (extraWhere) => {
  return extraWhere ? `WHERE ${extraWhere}` : ''
}

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
    const source = await resolvePassageSource()
    if (!source) {
      console.warn(`[${requestId}] Erreur lecture passages: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const tableRef = `"${source.schema}"."${source.table}"`
    const whereClause = buildWhere(source.extraWhere)
    const idSelect = source.idColumn
      ? `${source.idColumn} AS appareil_id`
      : 'NULL AS appareil_id'

    const result = await pool.query(
      `
        SELECT
          ${source.dateColumn} AS date_heure,
          ${source.typeColumn} AS type,
          ${idSelect}
        FROM ${tableRef}
        ${whereClause}
        ORDER BY ${source.dateColumn} DESC
        LIMIT $1
      `,
      [limit]
    )

    return res.json(result.rows)
  } catch (err) {
    console.error(`[${requestId}] Erreur lecture passages`, err.message)
    return res.status(500).json({ message: 'Impossible de récupérer les passages.' })
  }
})

export default router
