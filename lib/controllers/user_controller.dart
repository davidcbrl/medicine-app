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
  var buddy = Buddy(name: '', phone: '').obs;
  var image = ''.obs;

  var loading = false.obs;

  @override
  onInit() {
    super.onInit();
    if (isAuthenticated()) {
      get();
    }
  }

  Future<void> save() async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      if (image.isNotEmpty) {
        String imageVersion = UniqueKey().hashCode.toString();
        image.value = '${image.value}?v=$imageVersion';
      }
      UserRequest request = UserRequest(
        user: User(
          id: id.value == 0 ? null : id.value,
          name: name.value,
          phone: phone.value,
          email: email.value,
          password: password.value,
          image: image.isNotEmpty ? image.value : null,
          buddy: buddy.value,
          device: await getDeviceName(),
        ),
      );
      await ApiProvider.post(
        path: request.user.id != null ? '/user' : '/register',
        data: request.user.toJson(),
      );
      get();
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao salvar usuário: $error'));
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

  Future<void> passwordReset({required String currentPassword, required String newPassword}) async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      UserPasswordResetRequest request = UserPasswordResetRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPassword,
      );
      await ApiProvider.post(
        path: '/password',
        data: request.toJson(),
      );
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao alterar senha'));
      loading.value = false;
    }
  }

  void select(User user) {
    id.value = user.id ?? 0;
    name.value = user.name;
    phone.value = user.phone;
    email.value = user.email;
    password.value = user.password ?? '';
    buddy.value = user.buddy ?? Buddy(name: '', phone: '');
    image.value = user.image ?? '';
  }

  void clear() {
    id = 0.obs;
    name = ''.obs;
    phone.value = '';
    email.value = '';
    password.value = '';
    image = ''.obs;
    buddy = Buddy(name: '', phone: '').obs;
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

  bool isAuthenticated() {
    String token = StorageProvider.readJson(key: '/auth');
    return token != '{}';
  }
}
