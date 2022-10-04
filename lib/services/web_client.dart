import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'http_interceptors.dart';

class WebClient {
  //TODO: Adicionar seu IP aqui, use "ipconfig" no Windows ou "ifconfig" no Linux.
  static const String url = "http://SEU_IP_AQUI:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(seconds: 5),
  );
}
