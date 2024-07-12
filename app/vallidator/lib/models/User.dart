class User {
  int id;
  String? nome;
  String? sobrenome;
  String? telefone;
  String email;
  String? senha;
  String permissao;

  User({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.telefone,
    required this.email,
    this.senha,
    required this.permissao,
  });

  User.empty()
      : id = 0,
        nome = "",
        sobrenome = "",
        telefone = "",
        email = "",
        senha = "",
        permissao = "";

  User.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        nome = data['nome'] ?? "",
        sobrenome = data['sobrenome'] ?? "",
        telefone = data['telefone'] ?? "",
        email = data['email'],
        senha = data['senha'] ?? "",
        permissao = data['permissao'] ?? "";

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'permissao': permissao,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, nome: $nome, sobrenome: $sobrenome, telefone: $telefone, email: $email, permissao: $permissao}';
  }
}
