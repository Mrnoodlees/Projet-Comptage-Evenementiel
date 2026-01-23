// index.js
import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import passagesRoutes from './routes/passages.js'

dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

app.use('/api/passage', passagesRoutes)

app.listen(process.env.PORT, () => {
  console.log('API démarrée sur le port', process.env.PORT)
})
