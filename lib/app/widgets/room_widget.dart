import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomWidget {
  static Widget roomfield(Group group, Room room) {
    final socketio = Get.find<SocketioControllerV2>();

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              showMenu(
                color: Colors.grey.shade800,
                context: Get.context!,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx + 1,
                  details.globalPosition.dy + 1,
                ),
                items: [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Düzenle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Text(
                          'Sil',
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(Icons.delete, color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  if (kDebugMode) {
                    print("Seçilen: $value");
                  }
                }

                if (value == "delete") {
                  socketio.deleteRoom(room, group);
                }
              });
            },
            child: ListTile(
              onTap: () {
                socketio.changeroom(room);
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  room.type == RoomType.text
                      ? Icons.tag
                      : Icons.volume_up_rounded,
                ),
              ),
              title: Text(
                room.name.value,
                style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(room.currentMembers.length.toString()),
              ),
            ),
          ),
        ),
        ...List.generate(
          room.currentMembers.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                onTap: () {
                  socketio.callUser(room.currentMembers[index]);
                },
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: socketio.isSoundStreaming.value == true
                        ? Colors.amber
                        : Colors.transparent,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(
                      room.currentMembers[index].user.avatar!.mediaURL.minURL
                          .value
                          .toString(),
                    ),
                    radius: 14,
                  ),
                ),
                title: Text(
                  room.currentMembers[index].user.displayName!.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      room.currentMembers[index].microphone.value != true
                          ? Icon(
                              Icons.mic_off,
                              color: room.currentMembers[index].microphoneAccess
                                          .value ==
                                      true
                                  ? Colors.red
                                  : Colors.grey,
                              size: 20,
                            )
                          : Container(),
                      room.currentMembers[index].speaker.value != true
                          ? Icon(
                              Icons.headset_off,
                              color: room.currentMembers[index].speakerAccess
                                          .value ==
                                      true
                                  ? Colors.red
                                  : Colors.grey,
                              size: 20,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
