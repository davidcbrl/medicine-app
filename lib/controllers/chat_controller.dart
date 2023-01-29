import 'package:url_launcher/url_launcher.dart';

class ChatController {
  Future<void> launchWhatsapp() async {
    Uri url = Uri.parse('https://wa.me/+5541996194517?text=Preciso%20de%20ajuda%20com%20meu%20rem%C3%A9dio');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
