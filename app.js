import express from 'express';
import pg from 'pg'

const PORT=3000;
const app = express()

const { Pool } = pg;
const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

app.get('/hello', async (req,res)=>{
    try {
        const {rows} = await pool.query('SELECT username FROM users LIMIT 1')

        if (rows.length === 0) {
            return res.status(404).send('Nie znaleziono użytkownika.');
        }

        res.status(200).json({"msg": `Hello ${rows[0].username}`})
    } catch (error) {
        res.status(500).json({"msg":"Bład połaczenia z baza danych"})
    }
})

app.listen(PORT, () => {
    console.log(`Serwer działa na port ${PORT}`);
});