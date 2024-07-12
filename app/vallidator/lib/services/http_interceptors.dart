import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:vallidator/services/auth_service.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (request is Request) {
      logger.v(
          "Requisição para ${request.url}\nCabeçalhos: ${request.headers}\nCorpo: ${request.body}");
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode ~/ 100 == 2) {
      if (response is Response) {
        logger.i(
            "Resposta de ${response.request!.url}\nStatus da Resposta: ${response.statusCode}\n Cabeçalhos: ${response.headers}\nCorpo: ${response.body}");
      }
    } else {
      if (response is Response) {
        logger.e(
            "Resposta de ${response.request!.url}\nStatus da Resposta: ${response.statusCode}\n Cabeçalhos: ${response.headers}\nCorpo: ${response.body}");
      }
    }
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(true);
  }
}

class TokenInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String token = await AuthService.getUserToken();
    if (request is Request) {
      request.headers['Cookie'] = 'token=$token';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(true);
  }
}
