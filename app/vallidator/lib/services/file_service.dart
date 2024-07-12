import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:vallidator/services/auth_service.dart';
import 'package:vallidator/services/webclient.dart';
import 'package:http/http.dart' as http;

class FileService {
  String url = '${WebClient.url}arquivos/';
  Client client = WebClient().client;

  Future<bool> uploadFile(
      File file, int idTemplate, String caminho, bool depth) async {
    String token = await AuthService.getUserToken();

    var request = http.MultipartRequest('POST', Uri.parse('${url}validar'))
      ..files.add(await http.MultipartFile.fromPath('uploadedFile', file.path))
      ..fields['id_template'] = idTemplate.toString()
      ..fields['caminho'] = caminho
      ..fields['depth'] = depth ? '1' : '0'
      ..headers['Cookie'] = 'token=$token';

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    print('File uploaded succesfully: ${response.body}');
    return true;
  }

  Future<List<Map<String, dynamic>>> getRecentFiles() async {
    http.Response response = await client.get(Uri.parse('${url}recentes'));

    if (response.statusCode ~/ 100 != 2) {
      String content = response.body;
      throw HttpException(content);
    }

    List<Map<String, dynamic>> files =
        (jsonDecode(response.body) as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();

    return files;
  }

  Future<Map<String, dynamic>> getFileDashboardData() async {
    http.Response response = await client.get(Uri.parse('${url}data'));

    if (response.statusCode ~/ 100 != 2) {
      String content = response.body;
      throw HttpException(content);
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }
}
