import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/models/buddy.dart';
import 'package:medicine/models/user.dart';
import 'package:medicine/providers/api_provider.dart';
import 'package:medicine/providers/storage_provider.dart';

class UserController extends GetxController with StateMixin {
  PageController registerPageController = PageController();

  var id = 0.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var buddy = Buddy().obs;
  var image = ''.obs;

  var loading = false.obs;

  @override
  onInit() {
    get();
    super.onInit();
  }

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
          image: image.isNotEmpty ? image.value : "",
          buddy: buddy.value,
          device: await getDeviceName(),
        ),
      );
      await ApiProvider.post(
        path: '/register',
        data: request.user.toJson(),
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
      Map<String, dynamic> json = await ApiProvider.get(path: '/user');
      User user = User.fromJson(json);
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
    password.value = user.password ?? '';
    image.value = (user.image == 'image' ? null : user.image) ?? '';
  }

  void clear() {
    id = 0.obs;
    name = ''.obs;
    phone.value = '';
    email.value = '';
    password.value = '';
    image = ''.obs;
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.device}';
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return '${iosInfo.model} ${iosInfo.name}';
    }
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return '${webBrowserInfo.userAgent}';
    }
    return 'Unknown';
  }
}
