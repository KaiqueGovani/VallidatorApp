import express from 'express';
import { join } from 'path';

const router = express.Router();

// Caminho para o diretório atual
const __dirname = new URL('.', import.meta.url).pathname;

router.get('/', (req, res) => {
    res.redirect('/admin/dashboard');
});

router.get('/dashboard', (req, res) => {
    res.sendFile(join(__dirname, '../../frontend/admin/dashboard.html'));
});

router.get('/usuarios', (req, res) => {
    res.sendFile(join(__dirname, '../../frontend/admin/usuarios.html'));
});

router.get('/templates', (req, res) => {
    res.sendFile(join(__dirname, '../../frontend/admin/templates.html'));
});

router.use(express.static(join(__dirname, '../../frontend/admin')));

export default router;