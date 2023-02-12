class AlarmType {
  int id;
  String name;

  AlarmType({
    required this.id,
    required this.name,
  });

  AlarmType.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static List<AlarmType> getAlarmTypeList() {
    return [
      AlarmType(id: 1, name: 'Horário fixo'),
      AlarmType(id: 2, name: 'Intervalo de horas'),
    ];
  }
}
