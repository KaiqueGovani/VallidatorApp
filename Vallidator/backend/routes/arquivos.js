import { Router } from 'express';
import pool from '../config/database.js';
import { extname, basename } from 'path';
import autenticarToken from '../middlewares/autenticarToken.js';
import fetch from 'node-fetch';
import FormData from 'form-data';
import multer, { diskStorage } from 'multer';
import fs from 'fs';
import verificarPermissao from '../middlewares/verificarPermissao.js';

const router = Router();

const storage = diskStorage({
    destination: function (req, file, cb) {
        const dir = 'uploads/';
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir);
        }

        cb(null, dir)  // local onde o arquivo será salvo
    },
    filename: function (req, file, cb) {
        // Criando um carimbo de data/hora no formato 'YYYY-MM-DD_HH-mm-ss' com fusohorário de Brasília
        const date = new Date();
        const formattedDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}_${(date.getHours() - 3).toString().padStart(2, '0')}-${date.getMinutes().toString().padStart(2, '0')}-${date.getSeconds().toString().padStart(2, '0')}`;

        file.originalname = Buffer.from(file.originalname, 'latin1').toString('utf8')

        // Extrai a extensão do arquivo
        const fileExt = extname(file.originalname);
        // Extrai o nome do arquivo sem a extensão
        const fileName = basename(file.originalname, fileExt);

        // Combinando o nome original do arquivo, carimbo de data/hora e extensão
        cb(null, `${fileName}_${formattedDate}${fileExt}`);
    }
})

const upload = multer({ storage: storage });

router.post('/validar', verificarPermissao('upload'), upload.single('uploadedFile'), async (req, res) => {
    console.log("Recebendo arquivo...");

    console.log("Body:", req.body);

    // Verificações adicionais
    if (!req.file) {
        console.error("req.file é undefined!");
        return res.status(400).json({ mensagem: "Arquivo não enviado!" });
    }

    if (!req.body.id_template) {
        console.error("req.body.id_template é undefined!");
        return res.status(400).json({ mensagem: "ID do template não enviado!" });
    }

    if (req.body.caminho === undefined) {
        console.error("req.body.caminho é undefined!");
        return res.status(400).json({ mensagem: "Caminho do template não enviado!" });
    }

    if (req.body.depth === undefined) {
        console.error("req.body.depth é undefined!");
        return res.status(400).json({ mensagem: "Profundidade do template não enviada!" });
    }

    try {
        console.log("Enviando arquivo baseado em ", req.body.id_template, "por ", req.id);
        //Recriando form-data
        const form = new FormData();
        form.append('file', fs.createReadStream(req.file.path), req.file.filename);
        form.append('id_template', req.body.id_template);
        form.append('id_criador', req.id);// ! Utilizando o id do usuario logado pelo token
        form.append('caminho', req.body.caminho);
        form.append('depth', req.body.depth);

        const response = await fetch('http://flask:5000/validar', {
            method: 'POST',
            body: form,
            headers: form.getHeaders()
        });

        const data = await response.json();

        if (!response.ok) {
            // Incrementando o contador de uploads
            await pool.query('UPDATE uploaddata SET reprovados = reprovados + 1');
            res.status(400).json({ mensagem: data.mensagem || "Erro ao reencaminhar o arquivo!" });
        } else {
            // Salvando o arquivo no banco de dados
            try {
                const arquivo = {
                    nome: req.file.filename,
                    caminho: req.body.caminho + '/',
                    id_template: req.body.id_template,
                    id_criador: req.id,
                    tamanho_bytes: req.file.size
                }

                console.log("Arquivo:", arquivo);

                const query = 'INSERT INTO upload (id_template, id_usuario, nome, data, path, tamanho_bytes) VALUES ($1, $2, $3, $4, $5, $6)'
                const values = [arquivo.id_template, arquivo.id_criador, arquivo.nome, new Date(), arquivo.caminho, arquivo.tamanho_bytes];

                await pool.query(query, values);

                // Incrementando o contador de uploads
                await pool.query('UPDATE uploaddata SET aprovados = aprovados + 1');

                res.status(202).json({ mensagem: data.mensagem || "Arquivo enviado com sucesso" });

            } catch (error) {
                console.error(`Erro ao salvar o arquivo no banco de dados. \n${error.message}`);
                res.status(500).json({ mensagem: `Erro ao salvar o arquivo no banco de dados. \nFale com um administrador.` });
            }
        }

        // Deletar o arquivo do servidor Node.js após enviar
        fs.unlink(req.file.path, err => {
            if (err) {
                console.error("Erro ao deletar o arquivo:", err);
            }
        });

    } catch (error) {
        console.error(`Erro ao reencaminhar o arquivo. \n${error.message}`);
        res.status(500).json({ mensagem: `Erro ao reencaminhar o arquivo. \n${error.message}` });
    }
});

router.get('/recentes', verificarPermissao(), async (req, res) => {
    try {
        const query = "SELECT * FROM upload ORDER BY data DESC LIMIT 10;"
        const uploads = await pool.query(query);
        res.status(200).json(uploads.rows);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar uploads recentes' });
    }
});

router.get('/data', verificarPermissao(), async (req, res) => {
    try {
        const query = "SELECT * FROM uploaddata;"
        const uploads = await pool.query(query);
        res.status(200).json(uploads.rows[0]);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar templates recentes' });
    }
});

router.get('/caminhos', async (req, res) => {
    try {
        const query = "SELECT DISTINCT path FROM upload ORDER BY path ASC;"
        const caminhos = await pool.query(query);
        res.status(200).json(caminhos.rows);
    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao buscar caminhos de arquivos' });    
    }   
});

export default router;