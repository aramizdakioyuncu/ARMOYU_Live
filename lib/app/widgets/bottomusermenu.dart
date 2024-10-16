import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/modules/webrtc/views/device_view.dart';
import 'package:armoyu_desktop/app/modules/webrtc/views/media_views.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(User user, Group? group) {
    var socketio = Get.find<SocketioController>();

    return Container(
      color: const Color.fromARGB(255, 24, 24, 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Obx(
              () => Visibility(
                visible: socketio.isInRoomanyWhereGroup(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            Get.context!,
                            MaterialPageRoute(
                              builder: (context) => GetDisplayMediaSample(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.videocam_rounded,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            Get.context!,
                            MaterialPageRoute(
                              builder: (context) => DeviceEnumerationSample(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.screen_share_rounded,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.speed,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
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
                      () => socketio.isInRoomanyWhereGroup() != true
                          ? Container()
                          : Text(
                              // "${socketio.findanyWhereGroup().name}/",
                              "${socketio.findanyWhereGroup().name}/${socketio.findmyRoomanyWhereGroup() == null ? "" : socketio.findmyRoomanyWhereGroup()!.name.toString()}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                    ),
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
                    //Maksat daha hızlı olması yoksa socket üzerindende eklenecek
                    socketio.exitroom();

                    socketio.changeroom(null);
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

                        socketio.userUpdate(user);
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

                        socketio.userUpdate(user);
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
