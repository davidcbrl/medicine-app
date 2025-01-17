import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medicine/providers/storage_provider.dart';

class DioProvider {
  final Dio _dio = Dio();

  DioProvider({required String baseUrl}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
    _setupInterceptor();
  }

  Future<dynamic> get(String path) async {
    return _dio.get(path);
  }

  Future<dynamic> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }

  void _setupInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      String token = StorageProvider.readJson(key: '/auth');
      if (token != '{}') {
        options.headers['Authorization'] = 'Bearer $token';
      }
      if (kDebugMode) {
        print('''
          [REQUEST]
          - METHOD: ${options.method}
          - PATH: ${options.baseUrl}${options.path}
          - HEADERS: ${options.headers.toString()}
          ${options.method.contains('P') ? '- PAYLOAD: ${jsonEncode(options.data)}' : ''}''');
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (kDebugMode) {
        print('''
          [RESPONSE]
          - STATUS: ${response.statusCode}
        ''');
      }
      return handler.next(response);
    }, onError: (DioException error, handler) {
      if (kDebugMode) {
        print('''
          [ERROR]
          - MESSAGE: $error
        ''');
      }
      return handler.next(error);
    }));
  }
}
