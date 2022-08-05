import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.v("Requisição para: ${data.baseUrl}\n${data.headers}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode ~/ 100 == 2) {
      logger.i(
          "Resposta de ${data.url}\n${data.headers}\n${data.statusCode}\n ${data.body}");
    } else {
      logger.e(
          "Resposta de ${data.url}\n${data.headers}\n${data.statusCode}\n ${data.body}");
    }
    return data;
  }
}
