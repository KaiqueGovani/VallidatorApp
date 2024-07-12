//? Analisar o a verificação pelo banco de dados ao inves do token ?
//? por conta de possivel incompatibilidade entre token salvos e informações recem atualizadas no banco de dados ?
function verificarPermissao(perm = 'admin'){
    return function (req, res, next) {
        console.log("Verificando permissão " + perm + " para " + req.id + " com permissão " + req.permissao);
        if (req.permissao === 'admin') {
            next();
        } else if (!req.permissao.includes(perm)) {
            if (req.method === 'GET') {
                console.log("Sem permissão, Redirecionando para /login");
                res.redirect('/login');
            } else {
                res.status(403).json({ mensagem: 'Você não tem permissão para acessar este recurso' });
            }
        } else {
            next();
        }
    }}

export default verificarPermissao;