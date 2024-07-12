import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vallidator/services/webclient.dart';

class AuthService {
  String url = '${WebClient.url}usuarios/';
  http.Client client = WebClient().client;
  http.Client loginClient = WebClient().loginClient;

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await loginClient
        .post(
      Uri.parse('${url}login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "senha": password,
      }),
    );

    if (response.statusCode != 200) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    await saveUserToken(json.decode(response.body)['token']);

    return true;
  }

  Future<String> getPermission() async {
    http.Response response = await client
        .get(Uri.parse('${url}obter-permissao'), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode != 200) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    String perm = json.decode(response.body)["permissao"];
    print("Permission: $perm");
    return perm;
  }

  static saveUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print("Getting token: $token");

    if (token.isEmpty || token == "") {
      throw TokenNotFoundException();
    }

    return token;
  }
}

class UserNotFoundException implements Exception {}

class TokenNotFoundException implements Exception {}
