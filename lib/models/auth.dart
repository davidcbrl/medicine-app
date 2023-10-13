class Auth {
  String email;
  String password;

  Auth({
    required this.email,
    required this.password,
  });

  Auth.fromJson(Map<String, dynamic> json):
    email = json['email'],
    password = json['password'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
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
