import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(User user) {
    final socketio = Get.find<SocketioController>(
      tag: user.id.toString(),
    );

    return Container(
      color: const Color.fromARGB(255, 24, 24, 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.signal_cellular_alt,
                          color: Colors.green,
                        ),
                        Obx(
                          () => Text(
                            "Bağlantı Kuruldu(${socketio.pingValue.value})",
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => socketio.selectedRoom.value == null
                          ? Container()
                          : Text(
                              "Sunucu/${socketio.selectedRoom.value!.name}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                    )
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.info_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Roomlist içindeki odalardan, currentMembers içinde mevcut kullanıcıyı sil
                    // Oda listesindeki her odayı dolaşalım
                    for (var room in socketio.roomlist.value!) {
                      // Kullanıcının currentMembers listesinde olup olmadığını kontrol et
                      room.currentMembers.removeWhere(
                        (member) => member.username == user.username,
                      );
                    }

                    socketio.changeroom(null);
                    socketio.selectedRoom.value = null;
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.call_end,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              minTileHeight: 0,
              leading: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(
                    user.avatar!.minUrl.toString(),
                  ),
                  radius: 16),
              title: Text(
                user.username.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Text(
                "#${user.id.toString()}",
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => InkWell(
                      onTap: () {
                        var speaker = user.speaker;
                        var mic = user.microphone;
                        mic.value = !mic.value;

                        if (mic.value == true && speaker.value == false) {
                          speaker.value = true;
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          user.microphone.value == true
                              ? Icons.mic
                              : Icons.mic_off_rounded,
                          size: 20,
                          color: user.microphone.value == true
                              ? Colors.grey
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        var speaker = user.speaker;
                        var mic = user.microphone;

                        speaker.value = !speaker.value;

                        mic.value = speaker.value;
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          user.speaker.value == true
                              ? Icons.headphones
                              : Icons.headset_off,
                          size: 20,
                          color: user.speaker.value == true
                              ? Colors.grey
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed("/settings");
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
