import 'package:armoyu_desktop/app/data/models/internetstatus_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(Player user) {
    var socketio = Get.find<SocketioControllerV2>();

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
                          // Navigator.push(
                          //   Get.context!,
                          //   MaterialPageRoute(
                          //     builder: (context) => GetDisplayMediaSample(),
                          //   ),
                          // );
                        },
                        child: const Icon(
                          Icons.videocam_rounded,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   Get.context!,
                          //   MaterialPageRoute(
                          //     builder: (context) => DeviceEnumerationSample(),
                          //   ),
                          // );
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
            Obx(
              () => socketio.isInRoomanyWhereGroup() != true
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  socketio.internetConnectionStatus.value.icon,
                                  Text(
                                    "${socketio.internetConnectionStatus.value.name}(${socketio.pingValue.value})",
                                    style: TextStyle(
                                      color: socketio
                                          .internetConnectionStatus.value.color,
                                    ),
                                  ),
                                ],
                              ),
                              socketio.isInRoomanyWhereGroup() != true
                                  ? Container()
                                  : Text(
                                      "${socketio.findanyWhereGroup().name}/${socketio.findmyRoomanyWhereGroup() == null ? "" : socketio.findmyRoomanyWhereGroup()!.name.toString()}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                            ],
                          ),
                        ),
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
            ),
            ListTile(
              minTileHeight: 0,
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    user.user.avatar!.mediaURL.minURL.value.toString(),
                  ),
                  radius: 16),
              title: Text(
                user.user.userName!.value.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Text(
                "#${user.user.userID.toString()}",
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
                        socketio.micOnOff(user);
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
                        socketio.speakerOnOff(user);
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
