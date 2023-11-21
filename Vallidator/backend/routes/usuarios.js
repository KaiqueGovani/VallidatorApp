import { Router } from 'express';
import { hash, compare } from 'bcrypt';
import path from 'path';
import gerarToken from '../middlewares/gerarToken.js';
import pool from '../config/database.js';
import verificarPermissao from '../middlewares/verificarPermissao.js';
import autenticarToken from '../middlewares/autenticarToken.js';
import enviarEmail from '../middlewares/enviarEmail.js';
import { lerTokenSenha } from '../middlewares/gerarTokenSenha.js';

const router = Router();

router.get('/dados', autenticarToken, async (req, res) => { // Pega os dados do usuario que está logado
    try {
        const query = 'SELECT * FROM usuario WHERE id = $1';
        const values = [req.id];

        const result = await pool.query(query, values);

        res.status(200).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao obter informações de usuário' });
    }
});

router.put('/dados', autenticarToken, verificarPermissao(), async (req, res) => { // Atualiza os dados do usuario
    try {
        const query = 'UPDATE usuario SET nome = $1, sobrenome = $2, telefone = $3, email = $4 WHERE id = $5';
        const values = [req.body.nome, req.body.sobrenome, req.body.telefone, req.body.email, req.body.id];

        await pool.query(query, values);

        res.status(201).json({ mensagem: 'Dados atualizados com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao atualizar dados de usuário' });
    }
});

router.patch('/dados', autenticarToken, async (req, res) => { // Atualiza os dados do usuario que está logado
    try {
        const query = 'UPDATE usuario SET nome = $1, sobrenome = $2, telefone = $3 WHERE id = $4';
        const values = [req.body.nome, req.body.sobrenome, req.body.telefone, req.id];

        await pool.query(query, values);

        res.status(201).json({ mensagem: 'Dados atualizados com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao atualizar dados de usuário' });
    }
});

router.post('/criar', async (req, res) => {
    try {
        const { nome, sobrenome, telefone, email, senha, permissao } = req.body;

        const query = 'INSERT INTO usuario (nome, sobrenome, telefone, email, senha, permissao) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';

        //Hash da senha
        const saltRounds = 10;
        const hashSenha = await hash(senha, saltRounds);

        //Valores para inserçao
        const values = [nome, sobrenome, telefone, email, hashSenha, permissao];

        //Execura a query e responde a requisição
        const result = await pool.query(query, values);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao criar usuário' });
    }
});

router.post('/gerar-token', autenticarToken, verificarPermissao(), async (req, res) => {
    try {
        const email = req.body.email;
        console.log(email);

        // Verifica se o email já está cadastrado
        let query = 'SELECT * FROM usuario WHERE email = $1';
        let values = [email];

        const response = await pool.query(query, values);
        const usuario = response.rows[0];
        
        if (usuario) {
            res.status(409).json({ mensagem: 'Email já cadastrado' });
            return;
        }
        

        // Envia o email e insere o usuário no banco de dados
        await enviarEmail(email);

        const senhaAleatoria = Math.random().toString(36).slice(-8);

        query = 'INSERT INTO usuario (email, senha) VALUES ($1, $2)';
        values = [email, senhaAleatoria];

        await pool.query(query, values);

        res.status(201).json({ mensagem: 'Usuário convidado com sucesso' })
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao convidar usuário' });
    }
})

router.post('/gerar-token-alterar-senha', async (req, res) => {
    try {
        const email = req.body.email;
        const query = 'SELECT * FROM usuario WHERE email = $1';
        const values = [email];

        console.log(email);

        const result = await pool.query(query, values);
        const usuario = result.rows[0];
        console.log(usuario);

        if (usuario) {
            await enviarEmail(email);
            res.status(201).json({ mensagem: 'Email de redefinição de senha enviado!' });
        } else {
            res.status(404).json({ mensagem: 'Nenhum usuário com esse email foi encontrado' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao gerar token de nova senha' });
    }
});

router.get('/redefinir-senha/:token', async (req, res) => {
    try {
        const token = req.params.token;
        const dados = lerTokenSenha(token);
        const email = dados.email;

        if (dados.senha) {
            const query = 'SELECT * FROM usuario WHERE email = $1';
            const values = [email];

            const result = await pool.query(query, values);
            const usuario = result.rows[0];

            if (usuario) {
                res.redirect(`/login?redefinir=true&token=${token}`);
            } else {
                res.status(404).json({ mensagem: 'Email não encontrado' });
            }
        } else {
            res.status(401).json({ mensagem: 'Token inválido' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao redefinir senha' });
    }
});

router.post('/redefinir-senha', async (req, res) => {
    try {
        const { token, senha } = req.body;
        const email = lerTokenSenha(token).email;

        if (email) {
            const hashSenha = await hash(senha, 10);

            const query = 'UPDATE usuario SET senha = $1 WHERE email = $2';
            const values = [hashSenha, email];

            await pool.query(query, values);

            res.status(201).json({ mensagem: 'Senha redefinida com sucesso' });
        } else {
            res.status(401).json({ mensagem: 'Token inválido' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao redefinir senha' });
    }
});

router.get('/obter-permissao', autenticarToken, async (req, res) => {
    const permissao = req.permissao;
    res.status(200).json({ permissao: permissao });
});

router.post('/login', async (req, res) => {
    try {
        const { email, senha } = req.body;

        const query = 'SELECT * FROM usuario WHERE email = $1';
        const values = [email];

        const result = await pool.query(query, values);
        const usuario = result.rows[0];

        if (usuario) {
            const match = await compare(senha, usuario.senha);

            if (match) {
                const token = gerarToken(usuario.id, usuario.permissao);

                // Salva o token em um cookie
                // Configuração do cookie
                const cookieConfig = {
                    httpOnly: true,
                    maxAge: 24 * 60 * 60 * 1000, // 1 dia em milissegundos
                };

                // Define o cookie
                res.cookie('token', token, cookieConfig);

                // Redireciona para a página de templates
                res.status(200).json({
                    mensagem: 'Login realizado com sucesso!',
                    token: token,
                    redirect: usuario.permissao === 'admin' ? '../admin/dashboard' : '../templates'
                });

                //res.status(200).json({ mensagem: 'Login realizado com sucesso!', token: token, redirect: redirect, status: 200 });
            } else {
                res.status(401).json({ mensagem: 'Senha incorreta' });
            }
        } else {
            res.status(404).json({ mensagem: 'Email não encontrado' });
        }

    } catch (error) {
        console.log(error);
        res.status(500).json({ mensagem: 'Erro ao realizar o login' })
    }
});

router.post('/logout', async (req, res) => {
    res.clearCookie('token').json({ mensagem: 'Logout realizado com sucesso!' });
});

router.get('/listar', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM usuario ORDER BY id');
        res.status(200).json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao listar usuários' });
    }
});

router.delete('/deletar', autenticarToken, verificarPermissao(), async (req, res) => {
    try {
        const id = req.body.id;
        if (id === req.id) {
            res.status(401).json({ mensagem: 'Você não pode apagar a si mesmo' });
            return;
        }

        const result = await pool.query('DELETE FROM usuario WHERE id = $1', [id]);
        res.status(204).json({ mensagem: 'Usuário apagado!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao apagar usuário' })
    }
});

router.delete('/deletar-todos', async (req, res) => {
    try {
        const result = await pool.query('DELETE FROM usuario');
        res.status(204).json({ mensagem: 'Todos os usuários apagados!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao apagar todos os usuários' })
    }
});

router.patch('/permissao', autenticarToken, verificarPermissao(), async (req, res) => {
    try {
        // Verifica se o usuário é você mesmo
        if (req.body.id === req.id) {
            res.status(401).json({ mensagem: 'Você não pode alterar sua própria permissão' });
            return;
        }

        // Verifica se o usuário já possui a permissão
        let query = "SELECT * FROM usuario WHERE id = $1";
        let values = [req.body.id];

        const response = await pool.query(query, values);

        if (response.rows[0].permissao === req.body.permissao) {
            res.status(409).json({ mensagem: 'Usuário já possui essa permissão' });
            return;
        }

        query = "UPDATE usuario SET permissao = $1 WHERE id = $2";
        const { id, permissao } = req.body;
        values = [permissao, id];

        await pool.query(query, values);

        res.status(201).json({ mensagem: 'Permissão alterada com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ mensagem: 'Erro ao alterar permissão' });
    }
});

export default router;
