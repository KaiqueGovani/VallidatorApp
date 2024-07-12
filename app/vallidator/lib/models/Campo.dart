class Campo {
  int ordem;
  String nome_campo;
  String nome_tipo;
  int id_tipo;
  bool anulavel;

  Campo({
    required this.ordem,
    required this.nome_campo,
    required this.nome_tipo,
    required this.id_tipo,
    required this.anulavel,
  });

  Campo.fromMap(Map<String, dynamic> data)
      : ordem = data['ordem'],
        nome_campo = data['nome_campo'],
        nome_tipo = data['nome_tipo'],
        id_tipo = data['id_tipo'],
        anulavel = data['anulavel'];

  Map<String, dynamic> toMap() {
    return {
      'ordem': ordem,
      'nome_campo': nome_campo,
      'nome_tipo': nome_tipo,
      'id_tipo': id_tipo,
      'anulavel': anulavel,
    };
  }

  @override
  String toString() {
    return 'Campo{ordem: $ordem, nome_campo: $nome_campo, nome_tipo: $nome_tipo, id_tipo: $id_tipo, anulavel: $anulavel}';
  }
}
