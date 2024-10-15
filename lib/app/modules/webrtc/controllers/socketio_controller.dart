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
  var roomlist = Rxn<List<Room>>(null);
  var chatlist = Rxn<List<Message>>(null);
  var userList = Rxn<List<Groupmember>>(null);

  late IO.Socket socket;
  var socketChatStatus = false.obs;

  Timer? userListTimer;
  Timer? pingTimer;
  var pingID = "".obs;

  var pingValue = 0.obs; // Ping değerini reaktif hale getirdik
  DateTime? lastPingTime; // Son ping zamanı
  String socketPREFIX = "||SOCKET|| -> ";
  @override
  void onInit() {
    super.onInit();
    main();
  }

  @override
  void onClose() {
    // Controller kapandığında kaynakları temizle
    stopFetchingUserList();
    stopPing();
    socket.disconnect();
    super.onClose();
  }

  main() {
    // Socket.IO'ya bağlanma
    // socket = IO.io('http://mc.armoyu.com:2021', <String, dynamic>{
    socket = IO.io('http://localhost:2021', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Her 1 saniyede bir kullanıcı listesini iste
    startFetchingUserList(const Duration(seconds: 1));
    // Her 1 saniyede bir kullanıcı listesini iste

    startPing(const Duration(seconds: 1));
    // Ping değerini güncelle
    socket.on('ping', (data) {
      // Burada data yerine ping zamanı verilmez.
      pingValue.value = data; // Bu satırda hata var
      log('${socketPREFIX}Ping: ${pingValue.value} ms'); // Log ile göster
    });

    // Pong mesajını dinle
    socket.on('pong', (data) {
      // data içinde ping ID'sini al

      String pingId = data['id'];
      if (pingId != pingID.value) {
        log("PING ID eşleşmedi: Beklenen ${pingID.value}, gelen $pingId");
        return;
      }

      log("PING ID eşleşti");
      DateTime pongReceivedTime = DateTime.now(); // Pong zamanı
      if (lastPingTime != null) {
        // Ping süresini hesapla
        pingValue.value =
            pongReceivedTime.difference(lastPingTime!).inMilliseconds;
        print('Pong yanıtı alındı: $pingId');
        print('Ping süresi: ${pingValue.value} ms');
      }
    });
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
      registerUser(AppList.sessions.first.currentUser.username.toString(),
          AppList.sessions.first.currentUser.toJson());
    });

    // Bağlantı kesildiğinde
    socket.on('disconnect', (data) {
      try {
        log('$socketPREFIX$data');
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

    // Odalara giren çıkan
    socket.on('roomChanged', (data) {
      try {
        Room mm = Room.fromJson(data);
        log("$socketPREFIX${mm.name}");
      } catch (e) {
        log('${socketPREFIX}Hata (roomChanged): $e');
      }
    });

    socket.on('USER_LIST', (data) {
      try {
        var json = jsonDecode(data);

        log("${socketPREFIX}Member Count ${json.length}");
        for (var element in json) {
          Room? userRoom;
          if (element['room'] != null) {
            userRoom = Room.fromJson(element['room']);
          }

          User userInfo = User.fromJson(element['clientId']);

          bool kullanicivarmi = userList.value!.any(
            (element) => element.user.value.username == userInfo.username,
          );
          if (!kullanicivarmi) {
            userList.value!.add(
              Groupmember(
                user: userInfo.obs,
                description: "-",
                status: 0,
                currentRoom: userRoom?.obs,
              ),
            );
          } else {
            var a = userList.value!.firstWhere(
              (element) => element.user.value.username == userInfo.username,
            );

            a.user.value = userInfo;
            a.currentRoom = userRoom?.obs;
          }

          if (userRoom != null) {
            try {
              // Kullanıcıların Odaları Listeleniyor
              bool roomExists =
                  roomlist.value!.any((room) => room.name == userRoom!.name);

              // Eğer oda listede yoksa, ekle
              if (!roomExists) {
                roomlist.value!.add(userRoom);
              }

              bool? isUserinRoom;
              for (var room in roomlist.value!) {
                isUserinRoom = room.currentMembers
                    .any((member) => member.username == userInfo.username);
              }

              //Kullanıcı Odasında mı
              if (isUserinRoom!) {
                var currentRoom = roomlist.value!.firstWhere(
                  (room) => room.currentMembers
                      .any((member) => member.username == userInfo.username),
                );

                if (currentRoom != userRoom) {
                  for (var room in roomlist.value!) {
                    room.currentMembers.removeWhere(
                        (member) => member.username == userInfo.username);
                  }
                  roomlist.value!
                      .firstWhere((room) => room.name == userRoom!.name)
                      .currentMembers
                      .add(userInfo);
                }
              } else {
                for (var room in roomlist.value!) {
                  room.currentMembers.removeWhere(
                      (member) => member.username == userInfo.username);
                }
                roomlist.value!
                    .firstWhere((room) => room.name == userRoom!.name)
                    .currentMembers
                    .add(userInfo);
              }
            } catch (e) {
              log("qwwq -- $e");
            }
          } else {
            //Odalarda değilse Sil
            for (var room in roomlist.value!) {
              room.currentMembers.removeWhere(
                  (member) => member.username == userInfo.username);
            }
          }
        }
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

  void fetchUserList() {
    // Sunucudan kullanıcı listesi isteme
    socket.emit('USER_LIST', "");
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
      pingID.value = DateTime.now().millisecondsSinceEpoch.toString() +
          AppList.sessions.first.currentUser.id.toString();
      print('Ping gönderiliyor... ID: ${pingID.value}');
      lastPingTime = DateTime.now();
      socket.emit('ping', {'id': pingID.value}); // ID ile ping gönder
    });
  }

  void stopPing() {
    // Timer durdurma (iptal etme)
    if (pingTimer != null) {
      pingTimer!.cancel();
      pingTimer = null;
    }
  }

  void changeroom(Room? room) {
    log("oda değiştirildi");
    socket.emit('changeRoom', room?.toJson());
  }

////////
  void startFetchingUserList(Duration interval) {
    userListTimer = Timer.periodic(interval, (timer) {
      fetchUserList();
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
