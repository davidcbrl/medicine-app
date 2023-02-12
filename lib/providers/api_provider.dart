import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medicine/providers/dio_provider.dart';

class ApiProvider {
  static const baseUrl = 'http://api';

  static Future get({required String path}) async {
    try {
      Response response = await DioProvider(baseUrl: baseUrl).get(path);
      return response.data;
    } on DioError catch (error) {
      if (kDebugMode) print(error.response);
      return throw Exception('4XX');
    } catch (error) {
      return throw Exception('5XX');
    }
  }

  static Future put({required String path, dynamic data}) async {
    try {
      Response response = await DioProvider(baseUrl: baseUrl).put(path, data);
      return response.data;
    } on DioError catch (error) {
      if (kDebugMode) print(error.response);
      return throw Exception('4XX');
    } catch (error) {
      return throw Exception('5XX');
    }
  }

  static Future post({required String path, dynamic data}) async {
    try {
      Response response = await DioProvider(baseUrl: baseUrl).post(path, data);
      return response.data;
    } on DioError catch (error) {
      if (kDebugMode) print(error.response);
      return throw Exception('4XX');
    } catch (error) {
      return throw Exception('5XX');
    }
  }
}
