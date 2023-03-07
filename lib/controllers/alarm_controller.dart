import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/models/alarm_request.dart';
import 'package:medicine/models/alarm_type.dart';
import 'package:medicine/models/dose_type.dart';
import 'package:medicine/models/weekday_type.dart';
import 'package:medicine/providers/storage_provider.dart';

class AlarmController extends GetxController with StateMixin {
  PageController medicinePageController = PageController();
  PageController infoPageController = PageController();
  PageController reviewPageController = PageController();

  var id = 0.obs;
  var name = ''.obs;
  var quantity = 0.obs;
  var doseType = DoseType(id: 1, name: 'Gotas').obs;
  var image = ''.obs;
  var alarmType = AlarmType(id: 1, name: 'Horário fixo').obs;
  var timeList = <TimeOfDay>[const TimeOfDay(hour: 0, minute: 0)].obs;
  var weekdayTypeList = <WeekdayType>[].obs;
  var startDate = DateTime.now().obs;
  var observation = ''.obs;
  var alarmList = <Alarm>[].obs;

  var loading = false.obs;

  Future<void> save() async {
    change([], status: RxStatus.loading());
    loading.value = true;
    try {
      AlarmRequest request = AlarmRequest(
        alarm: Alarm(
          id: id.value == 0 ? null : id.value,
          name: name.value,
          quantity: quantity.value,
          image: image.isNotEmpty ? image.value : null,
          doseTypeId: doseType.value.id,
          alarmTypeId: alarmType.value.id,
          times: timeList.map((TimeOfDay element) => _decorateTime(element)).toList(),
          weekdayTypeIds: alarmType.value.id == 1 ? weekdayTypeList.map((WeekdayType element) => element.id).toList() : null,
          startDate: alarmType.value.id == 2 ? startDate.value : null,
          observation: observation.isNotEmpty ? observation.value : null,
        ),
      );
      alarmList.add(request.alarm);
      String json = jsonEncode(alarmList);
      bool result = await StorageProvider.writeJson('/alarms', json);
      if (!result) {
        throw Exception('Falha ao salvar alarme');
      }
      get();
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao salvar alarme'));
      loading.value = false;
    }
  }

  Future<void> get() async {
    change([], status: RxStatus.loading());
    loading.value = true;
    try {
      String json = await StorageProvider.readJson('/alarms');
      if (json == '{}') {
        alarmList.value = [];
        change([], status: RxStatus.empty());
        loading.value = false;
        return;
      }
      List<dynamic> alo = jsonDecode(json);
      alarmList.value = alo.map((element) => Alarm.fromJson(element)).toList();
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao buscar alarmes'));
      loading.value = false;
    }
  }

  void select(Alarm alarm) {
    id.value = alarm.id ?? 0;
    name.value = alarm.name;
    quantity.value = alarm.quantity;
    image.value = alarm.image ?? '';
    doseType.value = DoseType.getDoseTypeList().firstWhere(
      (DoseType element) => element.id == alarm.doseTypeId,
      orElse: () => DoseType(id: 1, name: 'Gotas'),
    );
    alarmType.value = AlarmType.getAlarmTypeList().firstWhere(
      (AlarmType element) => element.id == alarm.alarmTypeId,
      orElse: () => AlarmType(id: 1, name: 'Horário fixo'),
    );
    timeList.value = alarm.times.map(
      (String element) => _decorateTimeOfDay(element),
    ).toList();
    weekdayTypeList.value = WeekdayType.getWeekdayTypeList().where(
      (WeekdayType element) => alarm.weekdayTypeIds!.contains(element.id),
    ).toList();
    startDate.value = alarm.startDate ?? DateTime.now();
    observation.value = alarm.observation ?? '';
  }

  void clear() {
    id = 0.obs;
    name = ''.obs;
    quantity = 0.obs;
    image = ''.obs;
    doseType = DoseType(id: 1, name: 'Gotas').obs;
    alarmType = AlarmType(id: 1, name: 'Horário fixo').obs;
    timeList = <TimeOfDay>[const TimeOfDay(hour: 0, minute: 0)].obs;
    weekdayTypeList = <WeekdayType>[].obs;
    startDate = DateTime.now().obs;
    observation = ''.obs;
  }

  String _decorateTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _decorateTimeOfDay(String time) {
    List<String> splitted = time.split(':');
    return TimeOfDay(hour: int.parse(splitted[0]), minute: int.parse(splitted[1]));
  }
}
