import 'dart:convert';

class AddFriendRequestModel {
  final int kiminle;

  AddFriendRequestModel({
    required this.kiminle,
  });

  AddFriendRequestModel copyWith({
    int? kiminle,
  }) =>
      AddFriendRequestModel(
        kiminle: kiminle ?? this.kiminle,
      );

  factory AddFriendRequestModel.fromJson(String str) =>
      AddFriendRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddFriendRequestModel.fromMap(Map<String, dynamic> json) =>
      AddFriendRequestModel(
        kiminle: json["kiminle"],
      );

  Map<String, dynamic> toMap() => {
        "kiminle": kiminle,
      };
}
