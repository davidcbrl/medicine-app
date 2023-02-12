import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class DioProvider {
  String baseUrl = '';
  final Dio _dio = Dio();
  GetStorage box = GetStorage();
  bool isDanilo = false;

  DioProvider({required String baseUrl}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
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
      if (kDebugMode) print('REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path}');
      if (options.method.contains('P')) {
        if (kDebugMode) print('REQUEST[${options.method}] => PAYLOAD: ${options.data}');
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (kDebugMode) print('RESPONSE[${response.statusCode}]');
      return handler.next(response);
    }, onError: (DioError error, handler) {
      if (kDebugMode) print('ERROR\n[\n$error]');
      return handler.next(error);
    }));
  }
}
