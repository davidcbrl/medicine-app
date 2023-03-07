import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/models/alarm_request.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_calendar_carousel_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_list_item_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RouteController routeController = Get.put(RouteController(), permanent: true);
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);
  AlarmController alarmController = Get.put(AlarmController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    alarmController.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => LazyLoadScrollView(
                  isLoading: alarmController.loading.value,
                  scrollOffset: 10,
                  onEndOfPage: () => () {},
                  child: RefreshIndicator(
                    onRefresh: () => alarmController.get(),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (alarmController.status.isLoading) ...[
                          CustomLoadingWidget(
                            loading: alarmController.status.isLoading,
                          ),
                        ],
                        if (alarmController.status.isEmpty) ...[
                          const CustomEmptyWidget(
                            label: 'Nenhum alarme',
                          ),
                        ],
                        if (alarmController.status.isError) ...[
                          CustomEmptyWidget(
                            label: alarmController.status.errorMessage ?? 'Erro inesperado',
                          ),
                        ],
                        if (alarmController.status.isSuccess) ...[
                          ..._buildWidgetList(),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
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
                        Icons.mail_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
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
                      Icons.add_rounded,
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
                        Icons.access_time_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
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

  List<Widget> _buildWidgetList() {
    List<Alarm> list = [];
    for (Alarm alarm in alarmController.alarmList) {
      for (String time in alarm.times) {
        alarm.time = time;
        list.add(Alarm.fromJson(alarm.toJson()));
      }
    }
    list.sort((a, b) {
      int valueA = int.parse(a.time!.split(':')[0]);
      int valueB = int.parse(b.time!.split(':')[0]);
      return valueA.compareTo(valueB);
    });
    return list.map((Alarm alarm) => CustomListItemWidget(
      label: alarm.name,
      prefixLabel: alarm.time,
      buttonLabel: 'Toque para tomar',
      onPressed: () {
        alarmController.select(alarm);
      },
    )).toList();
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CustomSelectItemWidget(
                      label: 'Criar alarme para remédio',
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      onPressed: () {
                        alarmController.clear();
                        Get.back();
                        Get.toNamed('/alarm/medicine');
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
