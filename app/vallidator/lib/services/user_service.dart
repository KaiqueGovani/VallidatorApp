import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vallidator/models/User.dart';
import 'package:vallidator/services/webclient.dart';

class UserService {
  String url = '${WebClient.url}usuarios/';
  http.Client client = WebClient().client;

  Future<User> getUserData() async {
    http.Response response =
        await client.get(Uri.parse('${url}dados'), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode != 200) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return User.fromMap(json.decode(response.body));
  }

  Future<bool> updateUserData(bool isAdmin, User user) async {
    http.Response response;

    if (isAdmin) {
      response = await client.put(
        Uri.parse('${url}dados'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "nome": user.nome,
          "sobrenome": user.sobrenome,
          "telefone": user.telefone,
          "email": user.email,
          "id": user.id.toString(),
        }),
      );
    } else {
      response = await client.patch(
        Uri.parse('${url}dados'),
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          "nome": user.nome,
          "sobrenome": user.sobrenome,
          "telefone": user.telefone,
          "id": user.id.toString(),
        },
      );
    }

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return true;
  }

  Future<List<User>> getUsers() async {
    http.Response response =
        await client.get(Uri.parse('${url}listar'), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode != 200) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return (json.decode(response.body) as List)
        .map((e) => User.fromMap(e))
        .toList();
  }

  Future<bool> inviteUser(String email) async {
    http.Response response = await client.post(Uri.parse('${url}gerar-token'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
        }));

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return true;
  }

  Future<bool> patchUserPermission(User user, String perm) async {
    print('patching permission of user ${user.id} to $perm');
    http.Response response = await client.patch(
      Uri.parse('${url}permissao'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "permissao": perm,
        "id": user.id.toString(),
      }),
    );

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return true;
  }

  Future<bool> deleteUser(User user) {
    return client
        .delete(
      Uri.parse('${url}deletar'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "id": user.id,
      }),
    )
        .then((http.Response response) {
      if (response.statusCode ~/ 100 != 2) {
        String content = json.decode(response.body)['mensagem'];
        throw HttpException(content);
      }
      return true;
    });
  }
}

class UserNotFoundException implements Exception {}

class TokenNotFoundException implements Exception {}
