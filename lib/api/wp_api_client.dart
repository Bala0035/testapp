import 'package:dio/dio.dart';

import '../constants/config.dart';
import 'interceptor_logger.dart';

class WpApiClient {
  final Dio dio = Dio();

  WpApiClient() {
    dio.options.baseUrl = AppConfig.wpBaseUrl;
    //dio.interceptors.add(CoCartAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }
}