import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketioController extends GetxController {
  var selectedRoom = Rxn<Room>(null);

  // var chatlist = <Message>[].obs;
  // var userList = <Groupmember>[].obs; // Kullanıcı listesini burada saklayacağız
  var chatlist = Rxn<List<Message>>(null);
  var userList = Rxn<List<Groupmember>>(null);
  late IO.Socket socket;
  var socketChatStatus = false.obs;

  Timer? userListTimer;

  String socketPREFIX = "||SOCKET|| -> ";
  @override
  void onInit() {
    super.onInit();
    main();
  }

  main() {
    // Socket.IO'ya bağlanma
    socket = IO.io('http://mc.armoyu.com:2021', <String, dynamic>{
      // socket = IO.io('http://localhost:2021', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Her 5 saniyede bir kullanıcı listesini iste
    startFetchingUserList({'key': 'value'}, const Duration(seconds: 1));

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      log(socketPREFIX + data.toString());
    });
    // Bağlantı başarılı olduğunda
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');

      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      socketChatStatus.value = true;

      // Kullanıcıyı kaydet
      registerUser('KullaniciAdi', AppList.sessions.first.currentUser.toJson());
    });

    // Bağlantı kesildiğinde
    socket.on('disconnect', (data) {
      try {
        log('${socketPREFIX}$data');
      } catch (e) {
        log('${socketPREFIX}Hata (disconnect): $e');
      }
      log('${socketPREFIX}Bağlantı kesildi');
      socketChatStatus.value = false;
    });

    // Sunucudan gelen mesajları dinleme
    socket.on('chat', (data) {
      try {
        // print('Sunucudan gelen ham veri: $data');
        Message mm = Message.fromJson(data);
        log("$socketPREFIX${mm.user.value.displayname} - ${mm.message}");

        chatlist.value!.add(mm);

        chatlist.refresh();
      } catch (e) {
        log('${socketPREFIX}Hata (chat): $e');
      }
    });

    socket.on('USER_LIST', (data) {
      try {
        var json = jsonDecode(data);

        userList.value = [];
        log("${socketPREFIX}Member Count ${json.length}");
        for (var element in json) {
          userList.value!.add(
            Groupmember(
              user: User.fromJson(element['clientId']),
              description: "asd",
              status: 0,
            ),
          );
        }
        //
      } catch (e) {
        log('${socketPREFIX}Hata (USER_LIST): $e');
      }
    });

    // Otomatik olarak bağlanma
    socket.connect();

    return this;
  }

  // Socket.io ile mesaj gönderme
  void sendMessage(Message data) {
    socket.emit("chat", data.toJson());
  }

  // Kullanıcıyı sunucuya kaydetme
  void registerUser(String name, dynamic clientId) {
    socket.emit('REGISTER', {
      'name': name,
      'clientId': clientId,
    });
  }

  void fetchUserList(dynamic data) {
    // Sunucudan kullanıcı listesi isteme
    socket.emit('USER_LIST', data);
  }

  void startFetchingUserList(dynamic data, Duration interval) {
    // Timer.periodic ile belirli aralıklarla user listesi iste
    userListTimer = Timer.periodic(interval, (timer) {
      fetchUserList(data);
    });
  }

  void stopFetchingUserList() {
    // Timer durdurma (iptal etme)
    if (userListTimer != null) {
      userListTimer!.cancel();
      userListTimer = null;
    }
  }
}
