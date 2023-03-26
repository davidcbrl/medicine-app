import 'package:flutter/material.dart';
import 'package:medicine/models/weekday_type.dart';

class MedicineNotification {
  int id;
  String title;
  String image;
  String? body;
  String? largeIcon;
  TimeOfDay? time;
  WeekdayType? weekday;
  DateTime? fixedDate;
  Map<String, String?>? payload;

  MedicineNotification({
    required this.id,
    required this.title,
    required this.image,
    this.largeIcon,
    this.body,
    this.time,
    this.weekday,
    this.fixedDate,
    this.payload,
  });

  MedicineNotification.fromJson(Map<String, dynamic> json):
    id = json['id'],
    title = json['title'],
    image = json['image'],
    body = json['body'],
    largeIcon = json['largeIcon'],
    time = json['time'],
    weekday = json['weekday'],
    fixedDate = json['fixedDate'],
    payload = json['payload'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'body': body,
    'largeIcon': largeIcon,
    'time': time,
    'weekday': weekday,
    'fixedDate': fixedDate,
    'payload': payload,
  };
}
