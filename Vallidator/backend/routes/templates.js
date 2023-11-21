import { Router } from 'express';
import { join } from 'path';
import pool from '../config/database.js';
import autenticarToken from '../middlewares/autenticarToken.js';
import fetch from 'node-fetch';
import verificarPermissao from '../middlewares/verificarPermissao.js';

const router = Router();

// Caminho para o diretório atual
const __dirname = new URL('.', import.meta.url).pathname;

router.get('/', async (req, res) => {
    if(req.permissao === 'admin'){
        res.redirect('../admin/templates');
    }else{
        res.sendFile(join(__dirname, '../../frontend/common/templates.html'));
    }
});

router.post('/criar', verificarPermissao('criar'), async (req, res) => { //authenticarToken para verificar a permissão
    try {
        const { nome, id_criador, extensao, campos } = req.body;

        const query = `
            INSERT INTO template (
                nome, 
                id_criador, 
                data_criacao, 
                extensao, 
                status
            ) VALUES (
                $1, 
                $2, 
                current_timestamp, 
                $3, 
                $4
            ) RETURNING *;
        `

        const values = [nome, req.id, extensao, (req.permissao === 'admin') ? 0 : null];

        //Adiciona o template:
        const temp = await pool.query(query, values);

        //Adiciona os campos:
        for (let i = 0; i < campos.length; i++) {
            const query = `INSERT INTO templatesCampos (id_template, id_tipo, ordem, nome_campo, anulavel)
                           VALUES ($1, $2, $3, $4, $5);`
            const values = [temp.rows[0].id, campos[i].id_tipo, i + 1, campos[i].nome_campo, campos[i].anulavel];

            await pool.query(query, values);
        }


        res.status(201).json({ mensagem: 'Template criado com sucesso', result: temp.rows[0] });

    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao criar template' });
    }
});

router.get('/listar', verificarPermissao(), async (req, res) => {
    try {
        const query = `
            SELECT
                t.id,
                t.nome,
                t.id_criador,
                t.data_criacao,
                t.extensao,
                t.status,
                json_agg(json_build_object(
                    'ordem', tc.ordem,
                    'id_tipo', tp.id,
                    'nome_tipo', tp.tipo,
                    'nome_campo', tc.nome_campo,
                    'anulavel', tc.anulavel
                )) AS campos,
                u.nome AS nome_criador
            FROM
                template t
            JOIN
                templatescampos tc ON t.id = tc.id_template
            JOIN
                tipos tp ON tc.id_tipo = tp.id
            JOIN
                usuario u ON t.id_criador = u.id
            GROUP BY
                t.id, t.nome, t.id_criador, t.data_criacao, t.extensao, t.status, u.nome
            ORDER BY
                t.id;
        `
        const templates = await pool.query(query);

        res.status(200).json(templates.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao listar templates' });
    }
});

router.get('/ativos', async (req, res) => {
    try {
        const id = req.id;
        const query = `
            SELECT
                t.id,
                t.nome,
                t.id_criador,
                t.data_criacao,
                t.extensao,
                t.status,
                json_agg(json_build_object(
                    'ordem', tc.ordem,
                    'id_tipo', tp.id,
                    'nome_tipo', tp.tipo,
                    'nome_campo', tc.nome_campo,
                    'anulavel', tc.anulavel
                )) AS campos,
                u.nome AS nome_criador
            FROM
                template t
            JOIN
                templatescampos tc ON t.id = tc.id_template
            JOIN
                tipos tp ON tc.id_tipo = tp.id
            JOIN
                usuario u ON t.id_criador = u.id
            WHERE
                t.status = true OR (t.id_criador = ${id} AND t.status IS NULL)
            GROUP BY
                t.id, t.nome, t.id_criador, t.data_criacao, t.extensao, t.status, u.nome
            ORDER BY
                t.id;
        `

        const templates = await pool.query(query);
        res.status(200).json(templates.rows);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar templates ativos' });
    }
});

router.get('/recentes', verificarPermissao(), async (req, res) => {
    try {
        const query = "SELECT * FROM template ORDER BY data_criacao DESC LIMIT 10;"
        const templates = await pool.query(query);
        res.status(200).json(templates.rows);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar templates recentes' });
    }
});

router.get('/data', verificarPermissao(), async (req, res) => {
    try {
        const query = `
        SELECT
            COUNT(CASE WHEN status = TRUE THEN 1 END) AS Ativo,
            COUNT(CASE WHEN status = FALSE THEN 1 END) AS Inativo,
            COUNT(CASE WHEN status IS NULL THEN 1 END) AS Pendente,
            COUNT(CASE WHEN extensao = 'csv' THEN 1 END) AS csv,
            COUNT(CASE WHEN extensao = 'xls' THEN 1 END) AS xls,
            COUNT(CASE WHEN extensao = 'xlsx' THEN 1 END) AS xlsx
        FROM
            template;`

        const templates = await pool.query(query);
        res.status(200).json(templates.rows[0]);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar templates em revisão' });
    }
});


router.get('/buscar', async (req, res) => {
    try {
        const busca = req.query.busca;
        console.log(busca);
        const query = `SELECT * FROM template 
                       WHERE nome ILIKE \'%${busca}%\'
                       OR id::text ILIKE \'%${busca}%\';`

        const templates = await pool.query(query);

        res.status(200).json(templates.rows);

    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar templates' });
    }
});

router.post('/download', async (req, res) => {
    try {
        const response = await fetch('http://flask:5000/download', {  // Replace with your Flask server URL
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(req.body)
        });

        
        if (!response.ok) {
            const data = await response.json();
            throw new Error(`Flask server responded with: ${response.status}, ${data.mensagem}`);
        }

        // Set the appropriate headers for file download
        const fileExtension = req.body.extensao || 'csv';
        const fileName = req.body.nome || 'download';
        res.setHeader('Content-Disposition', `attachment; filename=${fileName}.${fileExtension}`);
        res.setHeader('Content-Type', response.headers.get('content-type'));

        // Pipe the response stream directly to the client
        response.body.pipe(res);

    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao baixar o template' });
    }
});


router.put("/alterar", verificarPermissao(), async (req, res) => {
    try {
        const { id, nome, extensao, status, campos } = req.body;

        // Inicia a transação:
        await pool.query('BEGIN');

        const query = `
            UPDATE template 
            SET 
                nome = $1,  
                extensao = $2, 
                status = $3
            WHERE
                id = $4
        `

        const values = [nome, extensao, (status == null) ? 0 : status, id];

        //Atualiza o template:
        await pool.query(query, values);
        console.log(`Template ${id} atualizado com sucesso`);

        //Deleta os campos antigos:
        const queryDelete = `DELETE FROM templatesCampos WHERE id_template = $1`;
        await pool.query(queryDelete, [id]);
        console.log(`Campos do template ${id} deletados com sucesso`);

        //Adiciona os campos:
        for (let i = 0; i < campos.length; i++) {
            const query = `INSERT INTO templatesCampos (id_template, id_tipo, ordem, nome_campo, anulavel)
                           VALUES ($1, $2, $3, $4, $5);`
            const values = [id, campos[i].id_tipo, i + 1, campos[i].nome_campo, campos[i].anulavel];

            await pool.query(query, values);
        }

        // Finaliza a transação:
        await pool.query('COMMIT');

        res.status(201).json({ mensagem: 'Template atualizado com sucesso' });
    } catch (error) {
        // Cancela a transação:
        await pool.query('ROLLBACK');

        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao atualizar template' });
    }
});

router.patch('/status', verificarPermissao(), async (req, res) => {
    try {
        const query = "UPDATE template SET status = $1 WHERE id = $2";
        const { id, status } = req.body;
        const values = [status, id];

        await pool.query(query, values);

        res.status(201).json({ mensagem: 'Status do template atualizado com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao atualizar status do template' });
    }
});

router.delete('/deletar/:id', verificarPermissao(), async (req, res) => {

    try {
        const id = req.params.id;

        const query = 'DELETE FROM template WHERE id = $1';
        const values = [id];

        await pool.query('BEGIN');

        await pool.query(query, values);

        await pool.query('COMMIT');

        res.status(200).json({ mensagem: `Template deletado com sucesso: ${id}` });

    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: `Erro ao deletar o template: ${id}` })
    }

});

export default router;