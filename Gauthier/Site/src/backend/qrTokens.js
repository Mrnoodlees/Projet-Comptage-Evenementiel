import crypto from 'node:crypto'
import { pool } from './db.js'

let ensured = false

// Persistent QR tokens so links remain valid across restarts.
const ensureTable = async () => {
  if (ensured) return
  await pool.query(`
    CREATE TABLE IF NOT EXISTS qr_tokens (
      token text PRIMARY KEY,
      scope text NOT NULL,
      revoked boolean NOT NULL DEFAULT false,
      created_at timestamp without time zone DEFAULT NOW()
    )
  `)
  ensured = true
}

export const createQrToken = async (scope) => {
  await ensureTable()
  const token = crypto.randomUUID()
  await pool.query(`
    INSERT INTO qr_tokens (token, scope, revoked)
    VALUES ($1, $2, false)
  `, [token, scope])
  return token
}

export const verifyQrToken = async (scope, token) => {
  await ensureTable()
  const { rows } = await pool.query(`
    SELECT token
    FROM qr_tokens
    WHERE token = $1 AND scope = $2 AND revoked = false
    LIMIT 1
  `, [token, scope])
  return rows.length > 0
}

export const resetQrTokens = async (scope) => {
  await ensureTable()
  await pool.query(`
    UPDATE qr_tokens
    SET revoked = true
    WHERE scope = $1
  `, [scope])
}
