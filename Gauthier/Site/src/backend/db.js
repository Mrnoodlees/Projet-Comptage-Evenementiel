import pkg from 'pg'
const { Pool } = pkg

export const pool = new Pool({
  host: '178.32.107.35',
  user: 'gauthier',
  password: 'gauthierfdp',
  database: 'projet_ir',
  port: 5432
})
