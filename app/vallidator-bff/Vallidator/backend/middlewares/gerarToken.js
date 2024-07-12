import jwt from 'jsonwebtoken';

const segredo = 'segredo';

function gerarToken(id, permissao) {
    const token = jwt.sign({ id, permissao }, segredo, { expiresIn: '1h' });

    return token;
}

export default gerarToken;