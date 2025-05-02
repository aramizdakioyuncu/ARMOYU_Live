import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMemberWidget {
  static Widget listtile(Groupmember member) {
    final socketio = Get.find<SocketioControllerV2>();
    return Obx(() {
      return ListTile(
        leading: CircleAvatar(
          foregroundImage: CachedNetworkImageProvider(
            member.user.value.user.avatar!.mediaURL.minURL.value.toString(),
          ),
        ),
        onTap: () {
          socketio.callUser(member.user.value);
        },
        title: Text(
          member.user.value.user.displayName!.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          member.currentRoom.value == null
              ? member.description
              : "${member.currentRoom.value?.name}",
          // description,
          style: const TextStyle(
            color: Colors.grey,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}
