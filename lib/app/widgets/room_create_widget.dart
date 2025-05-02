import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCreateWidget {
  static void showAlertDialog(
      BuildContext context, Group group, SocketioControllerV2 socketio) {
    var textController = TextEditingController().obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oda Yarat'),
          content: const Text('Oluşturduğun oda anlık gözükür.'),
          actions: <Widget>[
            TextField(
              controller: textController.value,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  child: const Text('Kapat'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text('Oluştur'),
                  onPressed: () {
                    socketio.createRoom(
                      textController.value.text,
                      group,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
