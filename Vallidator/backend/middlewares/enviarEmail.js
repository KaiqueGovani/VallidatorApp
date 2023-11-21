import nodemailer from 'nodemailer';
import { gerarTokenSenha } from './gerarTokenSenha.js';
import mailService from '/config/mail-service.json' assert { type: "json" };

async function enviarEmail(email) {
    try {
        // Configuração do serviço de email
        const transporter = nodemailer.createTransport(mailService);
    
        // Gera o token
        const token = gerarTokenSenha(email);
    
        // Gera o link
        const link = "http://localhost:3000/usuarios/redefinir-senha/" + token;
    
        // Configuração da mensagem
        const mailOptions = {
            from: mailService.auth.user,
            to: email,
            subject: 'Convite para configurar sua senha',
            html: `<p>Por favor, clique no link abaixo para configurar sua senha:</p><a href="${link}">${link}</a>`
        };
    
        // Envia o email
        const info = await transporter.sendMail(mailOptions);
        console.log('Email enviado: %s', info.messageId);
            
    } catch (error) {
        console.error(error);
    }
}

export default enviarEmail;