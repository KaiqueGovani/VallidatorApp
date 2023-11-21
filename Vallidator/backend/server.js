// ! Melhorar o feedback do usuário em todas as rotas
// ! Validar e Sanitizar inputs em todas as rotas
// ! Analizar a necessidade de transação nas rotas
// ! Autenticar Token de rotas ??
import express from 'express';
import { join } from 'path';
import cookieParser from 'cookie-parser';
import adminRoutes from './routes/admin.js';
import arquivosRoutes from './routes/arquivos.js';
import dbRoutes from './routes/db.js';
import templatesRoutes from './routes/templates.js';
import tiposRoutes from './routes/tipos.js';
import usuariosRoutes from './routes/usuarios.js';
import autenticarToken from './middlewares/autenticarToken.js';
import verificarPermissao from './middlewares/verificarPermissao.js';
//import cors from 'cors';


const app = express();
const port = process.env.PORT || 3000;

// Caminho do diretório atual
const __dirname = new URL('.', import.meta.url).pathname;

// app.use(cors({
//     origin: 'https://bbbc-2804-fc0-c02b-301-b5bd-454d-a594-a1f9.ngrok-free.app',
//     credentials: true
// }));

// Middleware para processar JSON
app.use(express.json());
// Middleware para processar formulários HTML
app.use(express.urlencoded({ extended: true })); // Para analisar corpos de formulários HTML
// Midleware para processar cookies
app.use(cookieParser());

// Configurar rotas estáticas
app.use('/styles', express.static(join(__dirname, '../frontend/styles')));
app.use('/scripts', express.static(join(__dirname, '../frontend/scripts')));
app.use('/icons', express.static(join(__dirname, '../frontend/icons')));

app.use('/db', dbRoutes);



app.get('/', autenticarToken, (req, res) => {
    console.log("Logado como " + req.id + " com permissão " + req.permissao);
    if (req.permissao === 'admin') {
        res.redirect('../admin/dashboard')
    } else {
        res.redirect('../templates')
    }
});

app.get('/login', (req, res) => {
    res.sendFile(join(__dirname, '../frontend/public/login.html'));
})


app.use('/minha-conta', autenticarToken, express.static(join(__dirname, '../frontend/common/minha-conta.html')));

app.use('/common', autenticarToken, express.static(join(__dirname, '../frontend/common')));

app.use('/admin', autenticarToken, verificarPermissao(), adminRoutes);

app.use('/arquivos', autenticarToken, arquivosRoutes); // ! acessivel somente por Admins ?
app.use('/templates',autenticarToken, templatesRoutes);
app.use('/tipos', tiposRoutes)
app.use('/usuarios', usuariosRoutes);

// Inicia o Servidor
app.listen(port, () => {
    console.log(`Servidor rodando em ${'http://localhost:' + port + '/'}`);
});
