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
                        Icon(
                          Icons.signal_cellular_alt,
                          color: Colors.green,
                        ),
                        Text(
                          "Bağlantı Kuruldu",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                    Obx(
                      () => socketio.selectedRoom.value == null
                          ? Container()
                          : Text(
                              "Sunucu/${socketio.selectedRoom.value!.name}",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outlined),
                  iconSize: 18,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call_end),
                  iconSize: 18,
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
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.mic,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.headphones,
                        size: 20,
                        color: Colors.grey,
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
