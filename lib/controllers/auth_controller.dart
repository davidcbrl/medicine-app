import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/models/auth_request.dart';
import 'package:medicine/providers/storage_provider.dart';

class AuthController extends GetxController with StateMixin {
  var email = ''.obs;
  var password = ''.obs;

  var loading = false.obs;

  Future<void> login() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      AuthRequest request = AuthRequest(
        auth: Auth(
          email: email.value,
          password: password.value,
        ),
      );
      String json = jsonEncode(AuthResponse(token: 's3cr3t').toJson());
      StorageProvider.writeJson(key: '/auth/login', json: json);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao realizar login'));
      loading.value = false;
    }
  }

  Future<void> logout() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      if (isAuthenticated()) {
        StorageProvider.removeJson(key: '/auth/login');
      }
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao realizar logout'));
      loading.value = false;
    }
  }

  bool isAuthenticated() {
    String json = StorageProvider.readJson(key: '/auth/login');
    Map<String, dynamic> element = jsonDecode(json);
    String token = element.isEmpty ? '' : AuthResponse.fromJson(element).token;
    return token.isNotEmpty;
  }
}
