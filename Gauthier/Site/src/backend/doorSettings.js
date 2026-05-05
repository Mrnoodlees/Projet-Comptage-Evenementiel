import { pool } from './db.js'

let ensured = false

// Stores door-level flags such as PMR.
export const ensureDoorSettingsTable = async () => {
  // Table complémentaire au modèle capteur : elle stocke les choix faits dans l’admin.
  if (ensured) return
  await pool.query(`
    CREATE TABLE IF NOT EXISTS door_settings (
      door_id text PRIMARY KEY,
      is_pmr boolean NOT NULL DEFAULT false,
      updated_at timestamp without time zone DEFAULT NOW()
    )
  `)
  ensured = true
}

export const upsertDoorSetting = async (doorId, isPmr) => {
  // Upsert : crée la porte si elle n’existe pas, sinon met à jour son flag PMR.
  await ensureDoorSettingsTable()
  await pool.query(`
    INSERT INTO door_settings (door_id, is_pmr, updated_at)
    VALUES ($1, $2, NOW())
    ON CONFLICT (door_id)
    DO UPDATE SET is_pmr = EXCLUDED.is_pmr, updated_at = NOW()
  `, [doorId, isPmr])
}
