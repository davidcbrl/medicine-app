import 'package:flutter/material.dart';

class Alarm {
  int? id;
  String name;
  int quantity;
  int doseTypeId;
  String? image;
  int alarmTypeId;
  TimeOfDay time;
  List<int>? weekdayTypeIdList;
  DateTime? startDate;
  String observation;

  Alarm({
    this.id,
    required this.name,
    required this.quantity,
    required this.doseTypeId,
    this.image,
    required this.alarmTypeId,
    required this.time,
    this.weekdayTypeIdList,
    this.startDate,
    required this.observation,
  });

  Alarm.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    quantity = json['quantity'],
    doseTypeId = json['doseTypeId'],
    image = json['image'],
    alarmTypeId = json['alarmTypeId'],
    time = json['time'],
    weekdayTypeIdList = json['weekdayTypeIdList'],
    startDate = json['startDate'],
    observation = json['observation'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'doseTypeId': doseTypeId,
    'image': image,
    'alarmTypeId': alarmTypeId,
    'time': time,
    'weekdayTypeIdList': weekdayTypeIdList,
    'startDate': startDate,
    'observation': observation,
  };
}

class AlarmRequest {
  Alarm alarm;

  AlarmRequest({
    required this.alarm,
  });

  AlarmRequest.fromJson(Map<String, dynamic> json):
    alarm = json['alarm'];

  Map<String, dynamic> toJson() => {
    'alarm': alarm,
  };
}
