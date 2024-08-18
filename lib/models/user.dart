import 'package:medicine/models/buddy.dart';

class User {
  int? id;
  String name;
  String phone;
  String email;
  String? password;
  String? image;
  Buddy? buddy;
  String? device;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    this.buddy,
    this.image,
    this.device,
  });

  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    phone = json['phone'],
    email = json['email'],
    password = json['password'],
    buddy = json['buddy'] != null ? Buddy.fromJson(json['buddy']) : null,
    image = json['image'],
    device = json['device_name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
    'password_confirmation': password,
    'buddy': buddy?.toJson(),
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

class UserPasswordResetRequest {
  String currentPassword;
  String newPassword;
  String newPasswordConfirmation;

  UserPasswordResetRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  UserPasswordResetRequest.fromJson(Map<String, dynamic> json):
    currentPassword = json['current_password'],
    newPassword = json['password'],
    newPasswordConfirmation = json['password_confirmed'];

  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'password': newPassword,
    'password_confirmed': newPasswordConfirmation,
  };
}
