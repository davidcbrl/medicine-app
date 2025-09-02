import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends GetxController {
  Future<void> launchWhatsapp({required String phone}) async {
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    String text = 'Preciso de ajuda com o meu medicamento';
    Uri chatUrl = Uri.parse('https://api.whatsapp.com/send?type=phone_number&phone=55$phone&text=$text');

    await launchUrl(chatUrl, mode: LaunchMode.platformDefault);
  }
}
