class Alarm {
  int? id;
  String name;
  int quantity;
  int doseTypeId;
  String? image;
  int alarmTypeId;
  String? time;
  List<String> times;
  List<int>? weekdayTypeIds;
  DateTime? startDate;
  String? observation;

  Alarm({
    this.id,
    required this.name,
    required this.quantity,
    this.image,
    required this.doseTypeId,
    required this.alarmTypeId,
    this.time,
    required this.times,
    this.weekdayTypeIds,
    this.startDate,
    this.observation,
  });

  Alarm.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    quantity = json['quantity'],
    image = json['image'],
    doseTypeId = json['doseTypeId'],
    alarmTypeId = json['alarmTypeId'],
    time = json['time'],
    times = json['times'].cast<String>(),
    weekdayTypeIds = json['weekdayTypeIds'].cast<int>(),
    startDate = json['startDate'],
    observation = json['observation'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'image': image,
    'doseTypeId': doseTypeId,
    'alarmTypeId': alarmTypeId,
    'time': time,
    'times': times,
    'weekdayTypeIds': weekdayTypeIds,
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
