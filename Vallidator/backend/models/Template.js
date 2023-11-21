class Template { //Classe para representar um template
    constructor(data){
        const {id, nome, id_criador, data_criacao, extensao, status, campos, nome_criador} = data;
        this.id = id;
        this.nome = nome;
        this.id_criador = id_criador; //-> Join usuario = nome_criador
        this.data_criacao = data_criacao;
        this.extensao = extensao;
        this.status = status;
        // Ordena os campos por ordem e mapeia para a classe Campo
        this.campos = campos.sort((a, b) => a.ordem - b.ordem).map(campo => new Campo(campo));
        this.nome_criador = nome_criador;
    }
}

class Campo { //Classe para representar um campo
    constructor(data){
        const {ordem, nome_campo, tipo, anulavel, id_template} = data;
        this.ordem = ordem;
        this.nome_campo = nome_campo;
        this.nome_tipo = typeMapping[tipo];
        this.tipo = tipo;
        this.anulavel = anulavel;
    }
}