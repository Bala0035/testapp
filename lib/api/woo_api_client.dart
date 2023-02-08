import 'package:dio/dio.dart';

import '../constants/config.dart';
import 'interceptor_logger.dart';
import 'interceptor_woo_auth.dart';

class WooApiClient {
  final Dio dio = Dio();

  WooApiClient() {
    dio.options.baseUrl = AppConfig.wooBaseUrl;
    dio.interceptors.add(WooAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }
}