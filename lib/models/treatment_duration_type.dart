class TreatmentDurationType {
  int id;
  String name;

  TreatmentDurationType({
    required this.id,
    required this.name,
  });

  TreatmentDurationType.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static List<TreatmentDurationType> getTreatmentDurationTypeList() {
    return [
      TreatmentDurationType(id: 1, name: 'Dia'),
      TreatmentDurationType(id: 2, name: 'Semana'),
      TreatmentDurationType(id: 3, name: 'Mês'),
    ];
  }

  static List<TreatmentDurationType> getTreatmentDurationTypeListStartingOnModay() {
    return [
      TreatmentDurationType(id: 1, name: 'Dia'),
      TreatmentDurationType(id: 2, name: 'Semana'),
      TreatmentDurationType(id: 3, name: 'Mês'),
    ];
  }
}
