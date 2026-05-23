import 'dart:convert';

class RegisterRequestModel {
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String password;

  RegisterRequestModel({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
  });

  RegisterRequestModel copyWith({
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? password,
  }) =>
      RegisterRequestModel(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory RegisterRequestModel.fromJson(String str) =>
      RegisterRequestModel.fromJson(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromMap(Map<String, dynamic> json) =>
      RegisterRequestModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "password": password,
      };
}
