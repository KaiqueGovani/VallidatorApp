import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:vallidator/services/http_interceptors.dart';

class WebClient {
  static const String url = "http://192.168.0.134:3000/";

  http.Client client = InterceptedClient.build(
      interceptors: [LoggingInterceptor(), TokenInterceptor()],
      requestTimeout: const Duration(seconds: 5),
      onRequestTimeout: () {
        throw TimeoutException('Request timed out');
      });

  http.Client loginClient = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
}
