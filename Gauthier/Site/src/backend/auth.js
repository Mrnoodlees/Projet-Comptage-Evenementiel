import crypto from 'crypto'

const HASH_PREFIX = 'scrypt$'

export const hashPassword = (password) => {
  const salt = crypto.randomBytes(16).toString('hex')
  const key = crypto.scryptSync(password, salt, 64)
  return `${HASH_PREFIX}${salt}$${key.toString('hex')}`
}

export const isHashedPassword = (value) => String(value || '').startsWith(HASH_PREFIX)

export const verifyPassword = (password, stored) => {
  if (!stored || typeof stored !== 'string') return false

  if (!stored.startsWith(HASH_PREFIX)) {
    return stored === password
  }

  const parts = stored.split('$')
  if (parts.length !== 3) return false
  const salt = parts[1]
  const hash = parts[2]
  if (!salt || !hash) return false

  const expected = Buffer.from(hash, 'hex')
  const actual = crypto.scryptSync(password, salt, expected.length)
  if (expected.length !== actual.length) return false
  return crypto.timingSafeEqual(expected, actual)
}

