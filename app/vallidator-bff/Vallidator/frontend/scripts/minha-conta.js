document.addEventListener('DOMContentLoaded', async function () {
    await verificarDados();
    await fetchUserData();
});

async function fetchUserData() {
    try {
        const response = await fetch('/usuarios/dados');

        const data = await response.json();
        console.log(data);

        popularDadosUsuario(data);
    } catch (error) {
        console.log("Erro ao obter informações de usuário:", error);
    }
}

async function popularDadosUsuario(dados) {
    const nome = document.getElementById('nome');
    const sobrenome = document.getElementById('sobrenome');
    const telefone = document.getElementById('telefone');
    const email = document.getElementById('email');
    const permissao = document.getElementById('permissao');
    const idUsuario = document.getElementById('idUsuario');

    nome.value = dados.nome;
    sobrenome.value = dados.sobrenome;
    telefone.value = dados.telefone;
    email.value = dados.email;
    idUsuario.value = dados.id;
    const permstr = [];

    if (dados.permissao === 'admin') {
        permstr.push('Administrador');
    } else {
        if (dados.permissao.includes('criar')) {
            permstr.push('Criar Templates');
        }
        if (dados.permissao.includes('upload')) {
            permstr.push('Upload de Arquivos');
        }
        if (dados.permissao.includes('ver')) {
            permstr.push('Ver');
        }
    }

    permissao.value = permstr.join(', ');
}

async function atualizarDadosUsuario() {
    const nome = document.getElementById('nome').value;
    const sobrenome = document.getElementById('sobrenome').value;
    const telefone = document.getElementById('telefone').value;

    const dados = {
        nome,
        sobrenome,
        telefone,
    }

    try {
        const response = await fetch(`/usuarios/dados`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(dados)
        });

        const data = await response.json();

        showFeedbackToast('Dados atualizados', 'Seus dados foram atualizados com sucesso', 'success', '../icons/badge-check.png');

        await fetchUserData();
    } catch (error) {
        console.log("Erro ao atualizar dados de usuário:", error);
    }
}

async function verificarDados() {
    const response = await fetch('usuarios/dados');
    const dados = await response.json();

    // verifica se algum valor dos dados é nulo ou "" e redireciona para minha-conta
    if (Object.values(dados).some(value => value == null || value == "")) {
        showFeedbackToast('Dados incompletos', 'Por favor, preencha seus dados antes de continuar', 'danger', '../icons/clock.png');
    }
}

