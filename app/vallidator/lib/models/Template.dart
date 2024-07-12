import 'package:vallidator/models/Campo.dart';

class Template {
  int id;
  String nome;
  int id_criador;
  String data_criacao;
  String extensao;
  bool? status;
  List<Campo> campos;
  String nome_criador;

  Template({
    required this.id,
    required this.nome,
    required this.id_criador,
    required this.data_criacao,
    required this.extensao,
    required List<Campo> campos,
    required this.status,
    required this.nome_criador,
  }) : campos = campos..sort((a, b) => a.ordem.compareTo(b.ordem));

  Template.create({
    required this.nome,
    required this.campos,
    required this.extensao,
  })  : id = 0,
        id_criador = 0,
        data_criacao = '',
        status = false,
        nome_criador = '';

  Template.empty()
      : id = 0,
        nome = '',
        id_criador = 0,
        data_criacao = '',
        extensao = '',
        status = false,
        campos = [],
        nome_criador = '';

  Template.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        nome = data['nome'],
        id_criador = data['id_criador'],
        data_criacao = data['data_criacao'],
        extensao = data['extensao'],
        status = data['status'],
        campos = (data['campos'] as List)
            .map((item) => Campo.fromMap(item))
            .toList()
          ..sort((a, b) => a.ordem.compareTo(b.ordem)),
        nome_criador = data['nome_criador'];

  Template.dashboardDataFromMap(Map<String, dynamic> data):
    id = data['id'],
    nome = data['nome'],
    id_criador = data['id_criador'],
    data_criacao = data['data_criacao'],
    extensao = data['extensao'],
    status = data['status'],
    campos = [],
    nome_criador = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'id_criador': id_criador,
      'data_criacao': data_criacao,
      'extensao': extensao,
      'status': status,
      'campos': campos.map((item) => item.toMap()).toList(),
      'nome_criador': nome_criador,
    };
  }

  @override
  String toString() {
    return 'Template{id: $id, nome: $nome, id_criador: $id_criador, data_criacao: $data_criacao, extensao: $extensao, status: $status, campos: $campos, nome_criador: $nome_criador}';
  }
}
