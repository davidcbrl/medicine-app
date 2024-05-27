import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends GetxController {
  Future<void> launchWhatsapp({required String phone}) async {
    String text = 'Preciso de ajuda com o meu medicamento';
    Uri chatUrl = Uri.parse('https://api.whatsapp.com/send?type=phone_number&phone=$phone&text=$text');
    
    if (await canLaunchUrl(chatUrl)) {
      await launchUrl(chatUrl, mode: LaunchMode.externalApplication);
      return;
    }

    throw 'Não foi possível abrir: $chatUrl';
  }
}
