import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_calendar_carousel_widget.dart';
import 'package:medicine/widgets/custom_list_item_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetStorage box = GetStorage();
  RouteController routeController = Get.put(RouteController(), permanent: true);
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Widget> medicines = List.generate(10, (index) => const CustomListItemWidget());
    List<Widget> boxes = List.generate(2, (index) => const SizedBox(height: 100));
    return CustomPageWidget(
      hasPadding: false,
      hasBackgroundImage: true,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAvatarWidget(
                  image: Image.asset(
                    'assets/img/ben.png',
                    width: 50,
                  ),
                  label: 'Tio Ben',
                ),
                CustomSelectItemWidget(
                  label: 'Falar com meu \nresponsável',
                  image: Image.asset(
                    'assets/img/whatsapp.png',
                    width: 30,
                  ),
                  onPressed: () => chatController.launchWhatsapp(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const CustomCalendarCarouselWidget(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [...medicines, ...boxes],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => notificationController.createMedicineNotification(),
                  child: Column(
                    children: [
                      Icon(
                        Icons.outgoing_mail,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Testar alarme',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _optionsBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 30,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => notificationController.createMedicineNotificationScheduled(),
                  child: Column(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Alarmar em 10s',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _optionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'O que deseja fazer?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomSelectItemWidget(
                  label: 'Criar alarme para remédio',
                  icon: Icon(
                    Icons.chevron_right_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/alarm/medicine');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextButtonWidget(
                  label: 'Voltar',
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
