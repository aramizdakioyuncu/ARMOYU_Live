import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIGroupUser {
  List<UserInfo> user;

  APIGroupUser({
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user.map((player) => player.toJson()).toList(),
    };
  }

  factory APIGroupUser.fromJson(Map<String, dynamic> json) {
    return APIGroupUser(
      user: (json['user'] as List<dynamic>)
          .map((player) => UserInfo.fromJson(player))
          .toList(),
    );
  }
}
