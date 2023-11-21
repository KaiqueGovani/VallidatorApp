class Usuario {
    constructor(data) {
        const { id, nome, sobrenome, telefone, email, senha, permissao } = data;
        this.id = id;
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.telefone = telefone;
        this.email = email;
        this.senha = senha;
        this.permissao = permissao;
    }
}