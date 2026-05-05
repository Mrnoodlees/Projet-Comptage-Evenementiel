import crypto from 'node:crypto'
import { pool } from './db.js'

let ensured = false

// Persistent QR tokens so links remain valid across restarts.
const ensureTable = async () => {
  // Créée à la demande : évite d’avoir une migration obligatoire pour lancer l’API.
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
  // Scope permet de séparer plusieurs types de QR si besoin : admin, public, etc.
  await ensureTable()
  const token = crypto.randomUUID()
  await pool.query(`
    INSERT INTO qr_tokens (token, scope, revoked)
    VALUES ($1, $2, false)
  `, [token, scope])
  return token
}

export const verifyQrToken = async (scope, token) => {
  // Un token est valide seulement s’il existe, correspond au scope et n’est pas révoqué.
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
  // Révocation logique : on garde l’historique mais on bloque les anciens liens.
  await ensureTable()
  await pool.query(`
    UPDATE qr_tokens
    SET revoked = true
    WHERE scope = $1
  `, [scope])
}

export const listQrTokens = async (scope) => {
  // Utilisé pour connaître le nombre d’accès QR actifs.
  await ensureTable()
  const { rows } = await pool.query(`
    SELECT token
    FROM qr_tokens
    WHERE scope = $1 AND revoked = false
  `, [scope])
  return rows.map(row => row.token)
}
