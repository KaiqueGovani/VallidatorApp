import { Router } from 'express';
import pool from '../config/database.js';

const router = Router();

router.get('/listar', async (req, res) => {
    try{
        const query = "SELECT * FROM tipos;"
        const tipos = await pool.query(query);

        res.status(200).json(tipos.rows);
    } catch(error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao listar tipos'});
    }
})

export default router;