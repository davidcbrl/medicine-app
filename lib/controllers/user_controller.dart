import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/models/user.dart';
import 'package:medicine/providers/storage_provider.dart';

class UserController extends GetxController with StateMixin {
  var id = 0.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var image = ''.obs;

  var loading = false.obs;

  Future<void> save() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      UserRequest request = UserRequest(
        user: User(
          id: id.value == 0 ? UniqueKey().hashCode : id.value,
          name: name.value,
          phone: phone.value,
          email: email.value,
          password: password.value,
          image: image.isNotEmpty ? image.value : null,
        ),
      );
      String json = jsonEncode(request.user.toJson());
      StorageProvider.writeJson(key: '/user', json: json);
      get();
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao salvar usuário'));
      loading.value = false;
    }
  }

  Future<void> get() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      String json = StorageProvider.readJson(key: '/user');
      if (json == '{}') {
        clear();
        change([], status: RxStatus.empty());
        loading.value = false;
        return;
      }
      User user = User.fromJson(jsonDecode(json));
      select(user);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao buscar usuário'));
      loading.value = false;
    }
  }

  void select(User user) {
    id.value = user.id ?? 0;
    name.value = user.name;
    phone.value = user.phone;
    email.value = user.email;
    password.value = user.password;
    image.value = user.image ?? '';
  }

  void clear() {
    id = 0.obs;
    name = ''.obs;
    phone.value = '';
    email.value = '';
    password.value = '';
    image = ''.obs;
  }
}
