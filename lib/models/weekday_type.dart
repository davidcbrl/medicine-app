class WeekdayType {
  int id;
  String name;

  WeekdayType({
    required this.id,
    required this.name,
  });

  WeekdayType.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static List<WeekdayType> getWeekdayTypeList() {
    return [
      WeekdayType(id: 1, name: 'Dom'),
      WeekdayType(id: 2, name: 'Seg'),
      WeekdayType(id: 3, name: 'Ter'),
      WeekdayType(id: 4, name: 'Qua'),
      WeekdayType(id: 5, name: 'Qui'),
      WeekdayType(id: 6, name: 'Sex'),
      WeekdayType(id: 7, name: 'Sab'),
    ];
  }
}
