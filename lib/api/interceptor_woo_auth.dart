import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/config.dart';

class WooAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String basic = 'Basic ' + base64Encode(utf8.encode('${AppConfig.authPublicToken}:${AppConfig.authSecretToken}'));
    options.headers = ({'Authorization': '$basic'});
    super.onRequest(options, handler);
  }
}