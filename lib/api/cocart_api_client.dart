import 'package:dio/dio.dart';

import '../constants/config.dart';
import 'interceptor_cocart_auth.dart';
import 'interceptor_logger.dart';

class CoCartApiClient {
  final Dio dio = Dio();

  CoCartApiClient() {
    dio.options.baseUrl = AppConfig.coCartBaseUrl;
    dio.interceptors.add(CoCartAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }

  Dio withHeaders(Map<String, dynamic> headers) {
    dio.options.headers.clear();
    dio.options.headers.addAll(headers);
    return dio;
  }
}