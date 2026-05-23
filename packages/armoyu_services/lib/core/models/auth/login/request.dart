import 'dart:convert';

class LoginRequestModel {
  final String username;
  final String password;

  LoginRequestModel({
    required this.username,
    required this.password,
  });

  LoginRequestModel copyWith({
    String? username,
    String? password,
  }) =>
      LoginRequestModel(
        username: username ?? this.username,
        password: password ?? this.password,
      );

  factory LoginRequestModel.fromJson(String str) =>
      LoginRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginRequestModel.fromMap(Map<String, dynamic> json) =>
      LoginRequestModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "password": password,
      };
}
