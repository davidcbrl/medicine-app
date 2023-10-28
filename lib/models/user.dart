class User {
  int? id;
  String name;
  String phone;
  String email;
  String password;
  String? image;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.image,
  });

  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    phone = json['phone'],
    email = json['email'],
    password = json['password'],
    image = json['image'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
    'image': image,
  };
}

class UserRequest {
  User user;

  UserRequest({
    required this.user,
  });

  UserRequest.fromJson(Map<String, dynamic> json):
    user = json['user'];

  Map<String, dynamic> toJson() => {
    'user': user,
  };
}
