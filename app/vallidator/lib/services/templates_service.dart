import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/services/webclient.dart';

class TemplateService {
  String url = '${WebClient.url}templates/';
  http.Client client = WebClient().client;

  Future<List<Template>> listTemplates(bool isAdmin) async {
    http.Response response;

    if (isAdmin) {
      response = await client.get(
        Uri.parse('${url}listar'),
        headers: {
          "Content-Type": "application/json",
        },
      );
    } else {
      response = await client.get(
        Uri.parse('${url}ativos'),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }

    if (response.statusCode != 200) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    List<Template> templates = [];
    for (var item in json.decode(response.body)) {
      Template newTemplate = Template.fromMap(item);
      templates.add(newTemplate);
    }

    return templates;
  }

  Future<String> updateStatus(int id, bool status) async {
    print('Updating status of template $id to $status');

    http.Response response = await client.patch(
      Uri.parse('${url}status'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'status': status, 'id': id}),
    );

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return json.decode(response.body)['mensagem'];
  }

  Future<String> createTemplate(Template template) async {
    print('Creating template $template');

    http.Response response = await client.post(
      Uri.parse('${url}criar'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(template.toMap()),
    );

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return json.decode(response.body)['mensagem'];
  }

  Future<String> updateTemplate(Template template) async {
    print('Updating template $template');

    http.Response response = await client.put(
      Uri.parse('${url}alterar'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(template.toMap()),
    );

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return json.decode(response.body)['mensagem'];
  }

  Future<bool> deleteTemplate(int id) async {
    print('Deleting template $id');

    http.Response response =
        await client.delete(Uri.parse('${url}deletar/$id'), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return true;
  }

  Future<List<Template>> getRecentTemplates() async {
    http.Response response = await client.get(Uri.parse('${url}recentes'));

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    List<Template> templates = [];
    for (var item in json.decode(response.body)) {
      Template newTemplate = Template.dashboardDataFromMap(item);
      templates.add(newTemplate);
    }

    return templates;
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    http.Response response = await client.get(Uri.parse('${url}data'));

    if (response.statusCode ~/ 100 != 2) {
      String content = json.decode(response.body)['mensagem'];
      throw HttpException(content);
    }

    return json.decode(response.body);
  }

  Future<bool> downloadTemplate(Template template) async {
    try {
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        http.Response response = await client.post(
          Uri.parse('${url}download'),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(template.toMap()),
        );

        if (response.statusCode == 200) {
          //Getting directory to save files
          final directory = await getDownloadsDirectory();
          final filePath =
              '${directory!.path}/${template.nome}.${template.extensao}';

          //Saving the file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          print('File downloaded to $filePath');
          return true;
        }
      } else {
        throw Exception('Permission denied');
      }
    } catch (e) {
      throw Exception('Error downloading template: $e');
    }
    return false;
  }
}
