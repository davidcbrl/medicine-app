class CalendarStyle {
  int id;
  String name;

  CalendarStyle({
    required this.id,
    required this.name,
  });

  CalendarStyle.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static List<CalendarStyle> getCalendarStyleList() {
    return [
      CalendarStyle(id: 1, name: 'Retangular'),
      CalendarStyle(id: 2, name: 'Circular'),
    ];
  }
}
