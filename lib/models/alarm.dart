class Alarm {
  int? id;
  String name;
  String? date;
  int? quantity;
  int? doseTypeId;
  String? image;
  int? alarmTypeId;
  String? taken;
  String? time;
  List<String> times;
  List<int>? weekdayTypeIds;
  String? startDate;
  String? observation;

  Alarm({
    this.id,
    required this.name,
    this.date,
    this.quantity,
    this.image,
    this.doseTypeId,
    this.alarmTypeId,
    this.taken,
    this.time,
    required this.times,
    this.weekdayTypeIds,
    this.startDate,
    this.observation,
  });

  Alarm.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    date = json['date'],
    quantity = json['quantity'],
    image = json['image'],
    doseTypeId = json['doseTypeId'],
    alarmTypeId = json['alarmTypeId'],
    taken = json['taken'],
    time = json['hour'],
    times = (json['hour'] != null) && (json['hours'] == null) ? [json['hour']] : json['hours']?.cast<String>(),
    weekdayTypeIds = json['days']?.cast<int>(),
    startDate = json['startDate'],
    observation = json['observations'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date,
    'qty': quantity,
    'image': image,
    'type': doseTypeId,
    'type_interval': alarmTypeId,
    'taken': taken,
    'time': time,
    'hours': times,
    'days': weekdayTypeIds,
    'start_date': startDate,
    'observations': observation,
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

class AlarmResponse {
  Alarm alarm;

  AlarmResponse({
    required this.alarm,
  });

  AlarmResponse.fromJson(Map<String, dynamic> json):
    alarm = json['alarm'];

  Map<String, dynamic> toJson() => {
    'alarm': alarm,
  };
}
