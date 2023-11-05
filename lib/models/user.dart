class User {
  int? id;
  String name;
  String phone;
  String email;
  String password;
  String? image;
  String? device;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.image,
    this.device,
  });

  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    phone = json['phone'],
    email = json['email'],
    password = json['password'],
    image = json['image'],
    device = json['device_name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
    'password_confirmation': password,
    'image': image,
    'device_name': device,
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
