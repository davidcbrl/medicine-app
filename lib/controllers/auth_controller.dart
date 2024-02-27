import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/models/auth.dart';
import 'package:medicine/providers/api_provider.dart';
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
          device: await getDeviceName(),
        ),
      );
      String json = await ApiProvider.post(
        path: '/login',
        data: request.auth.toJson(),
      );
      StorageProvider.writeJson(key: '/auth', json: json);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao realizar login: $error'));
      loading.value = false;
    }
  }

  Future<void> logout() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      if (isAuthenticated()) {
        await ApiProvider.post(path: '/logout');
        StorageProvider.removeJson(key: '/auth');
      }
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao realizar logout'));
      loading.value = false;
    }
  }

  Future<void> reset() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao redefinir a senha'));
      loading.value = false;
    }
  }

  bool isAuthenticated() {
    String token = StorageProvider.readJson(key: '/auth');
    return token != '{}';
  }

  Future<String> getDeviceName() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        return '${webBrowserInfo.userAgent}';
      }
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.device}';
      }
      if (GetPlatform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.model} ${iosInfo.name}';
      }
      return 'NotFound';
    } catch (e) {
      return 'Unknown';
    }
  }
}
