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
    return CustomPageWidget(
      hasPadding: false,
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
                  label: 'Falar com minha família',
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
          _medicinesList(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
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

  Widget _medicinesList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: List.generate(10, (index) => const CustomListItemWidget()),
        ),
      ),
    );
  }
}
