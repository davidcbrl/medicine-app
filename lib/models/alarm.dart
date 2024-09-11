class Alarm {
  int? id;
  String name;
  String? date;
  String? hour;
  int? quantity;
  int? doseTypeId;
  String? image;
  int? alarmTypeId;
  String? taken;
  String? time;
  List<String> times;
  List<int>? weekdayTypeIds;
  String? startDate;
  int? treatmentDuration;
  int? treatmentDurationTypeId;
  String? observation;

  Alarm({
    this.id,
    required this.name,
    this.date,
    this.hour,
    this.quantity,
    this.image,
    this.doseTypeId,
    this.alarmTypeId,
    this.taken,
    this.time,
    required this.times,
    this.weekdayTypeIds,
    this.startDate,
    this.treatmentDuration,
    this.treatmentDurationTypeId,
    this.observation,
  });

  Alarm.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    date = json['date'],
    hour = json['hour'],
    quantity = json['qty'],
    image = json['image'],
    doseTypeId = json['type'],
    alarmTypeId = json['type_interval'],
    taken = json['taken'],
    time = json['hour'],
    times = (json['hour'] != null) && (json['hours'] == null) ? [json['hour']] : json['hours']?.cast<String>(),
    weekdayTypeIds = json['days']?.cast<int>(),
    startDate = json['startDate'],
    treatmentDuration = json['treatmentDuration'],
    treatmentDurationTypeId = json['treatmentDurationTypeId'],
    observation = json['observations'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date,
    'hour': hour,
    'qty': quantity,
    'image': image,
    'type': doseTypeId,
    'type_interval': alarmTypeId,
    'taken': taken,
    'time': time,
    'hours': times,
    'days': weekdayTypeIds,
    'start_date': startDate,
    'treatmentDuration': treatmentDuration,
    'treatmentDurationTypeId': treatmentDurationTypeId,
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
