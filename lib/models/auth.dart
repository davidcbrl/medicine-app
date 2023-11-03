class Auth {
  String email;
  String password;
  String device;

  Auth({
    required this.email,
    required this.password,
    required this.device,
  });

  Auth.fromJson(Map<String, dynamic> json):
    email = json['email'],
    password = json['password'],
    device = json['device'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'device_name': device,
  };
}

class AuthRequest {
  Auth auth;

  AuthRequest({
    required this.auth,
  });

  AuthRequest.fromJson(Map<String, dynamic> json):
    auth = json['auth'];

  Map<String, dynamic> toJson() => {
    'auth': auth,
  };
}

class AuthResponse {
  String token;

  AuthResponse({
    required this.token,
  });

  AuthResponse.fromJson(Map<String, dynamic> json):
    token = json['token'];

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}
