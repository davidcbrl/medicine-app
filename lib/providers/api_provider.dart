import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medicine/providers/dio_provider.dart';

class ApiProvider {
  static const baseUrl = 'http://54.227.153.203/api';

  static Future get({required String path}) async {
    try {
      Response response = await DioProvider(baseUrl: baseUrl).get(path);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) print(error);
      return throw Exception(error.message);
    } catch (error) {
      return throw Exception('Erro desconhecido');
    }
  }

  static Future post({required String path, dynamic data}) async {
    try {
      Response response = await DioProvider(baseUrl: baseUrl).post(path, data);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) print(error);
      return throw Exception(error.message);
    } catch (error) {
      return throw Exception('Erro desconhecido');
    }
  }
}
