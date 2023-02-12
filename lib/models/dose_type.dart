class DoseType {
  int id;
  String name;

  DoseType({
    required this.id,
    required this.name,
  });

  DoseType.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static List<DoseType> getDoseTypeList() {
    return [
      DoseType(id: 1, name: 'Gotas'),
      DoseType(id: 2, name: 'Pílulas'),
      DoseType(id: 3, name: 'Ampolas'),
    ];
  }
}
