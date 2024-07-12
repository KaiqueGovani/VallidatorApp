import jwt from 'jsonwebtoken';

const segredo = 'segredo';

function gerarTokenSenha(email, exp) {
    const token = jwt.sign({ email, senha: true }, segredo, { expiresIn: exp || '1h' });

    return token;
}

function lerTokenSenha(token) {
    const dados = jwt.verify(token, segredo);

    return dados;
}

export { gerarTokenSenha, lerTokenSenha };
