import express from 'express'
import { pool } from '../db.js'

const router = express.Router()

const tableCache = {
  source: null
}

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

const resolveInfluenceSource = async () => {
  if (tableCache.source) return tableCache.source

  const logPassages = await findTable('log_passages')
  const passages = await findTable('passages')
  const passage = await findTable('passage')

  if (logPassages) {
    const columns = await getColumns(logPassages.schema, logPassages.table)
    const dateColumn = columns.has('ts') ? 'ts' : columns.has('date_heure') ? 'date_heure' : null
    const typeColumn = columns.has('mode_passage') ? 'mode_passage' : columns.has('type') ? 'type' : null
    const extraWhere = columns.has('type_passage') ? "type_passage='FIN'" : ''

    if (dateColumn && typeColumn) {
      tableCache.source = {
        schema: logPassages.schema,
        table: logPassages.table,
        dateColumn,
        typeColumn,
        extraWhere
      }
      return tableCache.source
    }
  }

  if (passages) {
    const columns = await getColumns(passages.schema, passages.table)
    const dateColumn = columns.has('date_heure')
      ? 'date_heure'
      : columns.has('timestamp')
        ? 'timestamp'
        : null
    const typeColumn = columns.has('type') ? 'type' : null

    if (dateColumn && typeColumn) {
      tableCache.source = {
        schema: passages.schema,
        table: passages.table,
        dateColumn,
        typeColumn: 'type',
        extraWhere: ''
      }
      return tableCache.source
    }
  }

  if (passage) {
    const columns = await getColumns(passage.schema, passage.table)
    const dateColumn = columns.has('date_heure')
      ? 'date_heure'
      : columns.has('timestamp')
        ? 'timestamp'
        : null
    const typeColumn = columns.has('type') ? 'type' : null

    if (dateColumn && typeColumn) {
      tableCache.source = {
        schema: passage.schema,
        table: passage.table,
        dateColumn,
        typeColumn: 'type',
        extraWhere: ''
      }
      return tableCache.source
    }
  }

  return null
}

const buildWhere = (extraWhere, clause) => {
  return extraWhere ? `WHERE ${extraWhere} AND ${clause}` : `WHERE ${clause}`
}

router.get('/influence', async (req, res) => {
  const { from, to } = req.query
  const includeBase = req.query.include_base === '1'
  const requestId = req.requestId || 'no-id'

  if (!from || !to) {
    console.warn(`[${requestId}] Public influence: from/to manquant`)
    return res.status(400).json({ message: 'Paramètres from/to manquants.' })
  }

  try {
    const source = await resolveInfluenceSource()
    if (!source) {
      console.warn(`[${requestId}] Public influence: aucune table`)
      return res.status(500).json({ message: 'Aucune table de passages trouvée.' })
    }

    const whereClause = buildWhere(source.extraWhere, `${source.dateColumn} BETWEEN $1 AND $2`)
    const tableRef = `"${source.schema}"."${source.table}"`
    const result = await pool.query(
      `
        SELECT
          date_trunc('hour', ${source.dateColumn}) AS heure,
          COUNT(*) FILTER (WHERE ${source.typeColumn}='ENTREE') AS entrees,
          COUNT(*) FILTER (WHERE ${source.typeColumn}='SORTIE') AS sorties
        FROM ${tableRef}
        ${whereClause}
        GROUP BY heure
        ORDER BY heure
      `,
      [from, to]
    )

    console.log(`[${requestId}] Public influence rows=${result.rows.length}`)
    if (!includeBase) {
      return res.json(result.rows)
    }

    const baseWhere = buildWhere(source.extraWhere, `${source.dateColumn} < $1`)
    const baseResult = await pool.query(
      `
        SELECT
          COUNT(*) FILTER (WHERE ${source.typeColumn}='ENTREE') AS entrees,
          COUNT(*) FILTER (WHERE ${source.typeColumn}='SORTIE') AS sorties
        FROM ${tableRef}
        ${baseWhere}
      `,
      [from]
    )
    const baseEntries = Number(baseResult.rows[0]?.entrees || 0)
    const baseExits = Number(baseResult.rows[0]?.sorties || 0)
    const basePeople = Math.max(0, baseEntries - baseExits)

    return res.json({ base: basePeople, rows: result.rows })
  } catch (err) {
    console.error(`[${requestId}] Public influence erreur`, err.message)
    return res.status(500).json({ message: 'Erreur influence.' })
  }
})

export default router
