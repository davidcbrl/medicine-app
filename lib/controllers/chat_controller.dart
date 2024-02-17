import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends GetxController {
  Future<void> launchWhatsapp({required String phone}) async {
    String text = 'Preciso de ajuda com o meu medicamento';
    Uri url = Uri.parse('https://api.whatsapp.com/send?type=phone_number&phone=$phone&text=$text');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return;
    }

    throw 'Não foi possível abrir: $url';
  }
}
