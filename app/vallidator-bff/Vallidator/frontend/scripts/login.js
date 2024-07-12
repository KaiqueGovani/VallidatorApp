window.onload = function () {
    // Verifica se a página foi carregada com o parâmetro redefinir=true
    const urlParams = new URLSearchParams(window.location.search);
    const redefinir = urlParams.get('redefinir');
    const token = urlParams.get('token');

    if (redefinir === 'true' && token) {
        abrirModalAlteracaoSenha(token);
    }
    
};

document.getElementById("email").focus();

function mostrarSenha(event) {
    // Usa o inputGroup mais próximo do ícone clicado
    var inputGroup = event.target.closest('.input-group');
    var inputSenha = inputGroup.querySelector("input");
    var icone = inputGroup.querySelector("span");

    if (inputSenha.type == "password") {
        inputSenha.type = "text";
        icone.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                        <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                        <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                    </svg>`

    } else {
        inputSenha.type = "password";
        icone.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-slash-fill" viewBox="0 0 16 16">
                        <path d="m10.79 12.912-1.614-1.615a3.5 3.5 0 0 1-4.474-4.474l-2.06-2.06C.938 6.278 0 8 0 8s3 5.5 8 5.5a7.029 7.029 0 0 0 2.79-.588zM5.21 3.088A7.028 7.028 0 0 1 8 2.5c5 0 8 5.5 8 5.5s-.939 1.721-2.641 3.238l-2.062-2.062a3.5 3.5 0 0 0-4.474-4.474L5.21 3.089z" />
                        <path d="M5.525 7.646a2.5 2.5 0 0 0 2.829 2.829l-2.83-2.829zm4.95.708-2.829-2.83a2.5 2.5 0 0 1 2.829 2.829zm3.171 6-12-12 .708-.708 12 12-.708.708z" />
                    </svg>`
    }
}

document.getElementById('loginForm').addEventListener('submit', async function (event) {
    // Previne o envio do formulário
    event.preventDefault();

    // Cria um objeto FormData e o preenche com os campos do formulário
    const body = {
        email: document.getElementById('email').value,
        senha: document.getElementById('senha').value
    }

    // Envia o formulário assincronamente
    const response = await fetch('/usuarios/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body)
    })

    // Verifica se a requisição foi bem sucedida
    if (!response.ok) {
        const data = await response.json();
        console.log(data);
        showFeedbackToast('Erro', data.mensagem, 'danger', '/icons/ban.png');
        this.reset();
    } else {
        const data = await response.json();
        window.location.href = data.redirect;
    }
});

function abrirModalAlteracaoSenha() {
    // Abre o modal
    const novaSenhaModal = new bootstrap.Modal(document.getElementById('novaSenhaModal'));
    novaSenhaModal.show();
}

async function redefinirSenha() {

}

document.getElementById('novaSenhaForm').addEventListener('submit', async function (event) {
    // Previne o envio do formulário
    event.preventDefault();

    const novaSenha = document.getElementById('novaSenha').value;
    const confirmarSenha = document.getElementById('confirmarSenha').value;

    if (novaSenha !== confirmarSenha) {
        showFeedbackToast('Erro', 'As senhas devem ser iguais!', 'danger', '/icons/ban.png');
        return;
    }

    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');

    // Cria o corpo da requisição
    const body = {
        token: token,
        senha: novaSenha
    }

    // Envia o formulário assincronamente
    const response = await fetch('/usuarios/redefinir-senha', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body)
    })

    // Verifica se a requisição foi bem sucedida
    if (!response.ok) {
        const data = await response.json();
        console.log(data);
        showFeedbackToast('Erro', data.mensagem, 'danger', '/icons/ban.png');
    } else {
        window.location.href = '/login';
    }
});

document.getElementById('emailForm').addEventListener('submit', async function (event) {
    // Previne o envio do formulário
    event.preventDefault();

    // Mostra toast de carregamento
    showFeedbackToast('Enviando...', 'Enviando email...', 'warning', '../icons/clock.png');

    // Cria um objeto FormData e o preenche com os campos do formulário
    const body = {
        email: document.getElementById('envioEmail').value,
    }

    // Envia o formulário assincronamente
    const response = await fetch('/usuarios/gerar-token-alterar-senha', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body)
    })

    // Verifica se a requisição foi bem sucedida
    if (!response.ok) {
        const data = await response.json();
        console.log(data);
        showFeedbackToast('Erro', data.mensagem, 'danger', '/icons/ban.png');
    } else {
        const data = await response.json();
        showFeedbackToast('Sucesso', data.mensagem, 'success', '/icons/badge-check.png');
        // Fecha o modal
        const emailModal = bootstrap.Modal.getInstance(document.getElementById('emailModal'));
        emailModal.hide();
    }
});