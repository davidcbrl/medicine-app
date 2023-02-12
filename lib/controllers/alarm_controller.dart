import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/models/alarm_type.dart';
import 'package:medicine/models/dose_type.dart';
// import 'package:medicine/models/alarm_request.dart';
// import 'package:medicine/providers/api_provider.dart';

class AlarmController extends GetxController with StateMixin {
  PageController medicinePageController = PageController();
  PageController infoPageController = PageController();
  PageController reviewPageController = PageController();
  var name = ''.obs;
  var quantity = 0.obs;
  var doseType = DoseType(id: 1, name: 'Gotas').obs;
  var image = ''.obs;
  var alarmType = AlarmType(id: 1, name: 'Horário fixo').obs;
  var time = const TimeOfDay(hour: 0, minute: 0).obs;
  var weekdayTypeIdList = <int>[].obs;
  var startDate = DateTime.now().obs;
  var observation = ''.obs;

  Future<void> save() async {
    change([], status: RxStatus.loading());
    try {
      // AlarmRequest request = AlarmRequest(
      //   alarm: Alarm(
      //     name: name.value,
      //     quantity: quantity.value,
      //     doseTypeId: doseType.value.id,
      //     alarmTypeId: alarmType.value.id,
      //     time: time.value,
      //     observation: observation.value,
      //   ),
      // );
      // await ApiProvider.put(
      //   path: '/alarm',
      //   data: request.toJson(),
      // );
      change([], status: RxStatus.success());
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao salvar alarme'));
    }
  }
}
