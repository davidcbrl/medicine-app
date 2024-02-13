import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medicine/providers/storage_provider.dart';

class DioProvider {
  final Dio _dio = Dio();

  DioProvider({required String baseUrl}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
    );
    _setupInterceptor();
  }

  Future<dynamic> get(String path) async {
    return _dio.get(path);
  }

  Future<dynamic> put(String path, dynamic data) async {
    return _dio.put(path, data: data);
  }

  Future<dynamic> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }

  Future<dynamic> delete(String path) async {
    return _dio.delete(path);
  }

  void _setupInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (kDebugMode) print('[REQUEST] => METHOD: ${options.method}');
      if (kDebugMode) print('[REQUEST] => PATH: ${options.baseUrl}${options.path}');
      if (kDebugMode) print('[REQUEST] => HEADERS: ${options.headers.toString()}');
      if (options.method.contains('P')) if (kDebugMode) print('[REQUEST] => PAYLOAD: ${options.data}');
      String token = StorageProvider.readJson(key: '/auth');
      if (token != '{}') {
        options.headers['Authorization'] = 'Bearer $token';
        if (kDebugMode) print('REQUEST[${options.method}] => TOKEN: $token');
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (kDebugMode) print('[RESPONSE] => STATUS: ${response.statusCode}');
      return handler.next(response);
    }, onError: (DioException error, handler) {
      if (kDebugMode) print('[ERROR] => MESSAGE: $error');
      return handler.next(error);
    }));
  }
}
