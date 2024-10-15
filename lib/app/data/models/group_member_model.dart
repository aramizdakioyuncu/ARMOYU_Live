import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Groupmember {
  final User user;
  final String description;
  final int status;
  Groupmember({
    required this.user,
    required this.description,
    required this.status,
  });

  Widget listtile() {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(
          user.avatar!.minUrl.toString(),
        ),
      ),
      title: Text(
        user.displayname.toString(),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
