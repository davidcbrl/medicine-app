class Buddy {
  int? id;
  String? name;
  String? phone;

  Buddy({
    this.id,
    this.name,
    this.phone,
  });

  Buddy.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    phone = json['phone'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
  };
}
