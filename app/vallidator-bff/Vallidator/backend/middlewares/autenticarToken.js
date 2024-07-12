import jwt from 'jsonwebtoken';

const segredo = 'segredo';

export default (req, res, next) => {
    const token = req.cookies.token;

    if (token) {
        try {
            // Verifica o token
            const usuario = jwt.verify(token, segredo);

            // Adiciona o id e a permissão do usuário na requisição
            req.id = usuario.id;
            req.permissao = usuario.permissao;

            // Chama o próximo middleware
            next();
        } catch(error){
            res.clearCookie('token');
            if (req.method === 'GET') {
                res.redirect('/login');
            } else {
                res.status(403).json({ mensagem: 'Você não está logado' });
            }
        }
    } else {
        if (req.method === 'GET') {
            res.redirect('/login');
        } else {
            res.status(403).json({ mensagem: 'Você não está logado' });
        }
    }
}