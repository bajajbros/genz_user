class LoginResponse {
  final String status;
  final String token;
  final Data data;

  LoginResponse({
    required this.status,
    required this.token,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      token: json['token'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  User({
    required this.id,
  required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      phone: json['phone']?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}
