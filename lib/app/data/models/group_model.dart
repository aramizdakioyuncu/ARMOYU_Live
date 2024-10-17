import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_desktop/app/widgets/message_sendfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Group {
  final int groupID;
  final String name;
  final String description;
  final Media logo;
  RxList<Groupmember>? groupmembers;
  RxList<Room>? rooms;

  Group({
    required this.groupID,
    required this.name,
    required this.description,
    required this.logo,
    this.groupmembers,
    this.rooms,
  });

  // JSON'dan Group nesnesi oluşturma
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'],
      name: json['name'],
      description: json['description'],
      logo: Media.fromJson(
          json['logo']), // Media sınıfınızın da fromJson metodu olmalı
      groupmembers: (json['groupmembers'] as List<dynamic>?)
          ?.map((member) => Groupmember.fromJson(member))
          .toList()
          .obs, // RxList dönüşümü
      rooms: (json['rooms'] as List<dynamic>?)
          ?.map((room) => Room.fromJson(room))
          .toList()
          .obs,
    );
  }

  // Group nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'name': name,
      'description': description,
      'logo': logo.toJson(), // Media sınıfınızın toJson metodu olmalı
      'groupmembers': groupmembers?.map((member) => member.toJson()).toList(),
      'rooms': rooms?.map((room) => room.toJson()).toList(),
    };
  }

  void _showAlertDialog(BuildContext context, SocketioController socketio) {
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
                      Room(
                        groupID: groupID,
                        roomUUID: const Uuid().v1(),
                        name: textController.value.text,
                        limit: 10,
                        type: RoomType.voice,
                        message: <Message>[].obs,
                      ),
                      this,
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

  Widget pageDetail(BuildContext context) {
    var mainScrollController = ScrollController().obs;
    var membersScrollController = ScrollController().obs;
    var showMembers = false.obs;

    final socketio = Get.find<SocketioController>();

    var chattextcontroller = TextEditingController().obs;

    return Row(
      children: [
        Container(
          width: 250,
          color: const Color.fromARGB(255, 29, 29, 29),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: Text(name),
                  onTap: () {},
                  trailing: const Icon(Icons.settings),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showAlertDialog(context, socketio);
                  },
                  child: ListView(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              logo.minUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("1.Seviye"),
                              ),
                            ),
                            LinearProgressIndicator(
                              value: 0.2,
                              backgroundColor: Colors.black38,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Column(
                          children: List.generate(
                            socketio.findcurrentGroup(this).rooms!.length,
                            (index) {
                              return Obx(
                                () => socketio
                                    .findcurrentGroup(this)
                                    .rooms![index]
                                    .roomfield(this),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Bottomusermenu.field(AppList.sessions.first.currentUser, this),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Obx(
                    () => socketio.isInRoom(this) != true
                        ? Container()
                        : Icon(
                            socketio.findmyRoom(this)!.type == RoomType.text
                                ? Icons.tag
                                : Icons.volume_up,
                            color: Colors.grey,
                            size: 25,
                          ),
                  ),
                  const SizedBox(width: 5),
                  Obx(
                    () => Text(
                      socketio.isInRoom(this) != true
                          // socketio.selectedRoom.value == null
                          ? name
                          // : socketio.selectedRoom.value!.name.toString(),
                          : socketio.findmyRoom(this)!.name.toString(),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.push_pin_rounded,
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      isSelected: true,
                      onPressed: () {
                        showMembers.value = !showMembers.value;
                      },
                      icon: Icon(
                        Icons.group,
                        color: showMembers.value == true
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    height: 28,
                    child: TextField(
                      style: TextStyle(fontSize: 11),
                      decoration: InputDecoration(
                        hintText: "Arama",
                        hintStyle: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download,
                    ),
                  ),
                  const InkWell(
                    child: Text("@"),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.contact_support_sharp,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                color: Colors.black,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => socketio.isStreaming.value == true
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RTCVideoView(
                                                socketio.renderer,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade800,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0, // Alt kısma yerleştiriyoruz
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.screen_share_rounded),
                                        style: const ButtonStyle(
                                          iconColor: WidgetStatePropertyAll(
                                            Colors.black,
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () {},
                                        style: const ButtonStyle(
                                          iconColor: WidgetStatePropertyAll(
                                            Colors.black,
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                        ),
                                        icon: const Icon(Icons.mic_off),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () {},
                                        style: const ButtonStyle(
                                          iconColor: WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.red,
                                          ),
                                        ),
                                        icon: const Icon(Icons.call_end),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Expanded(
                              child: socketio.isInRoom(this) != true
                                  ? Container()
                                  : Stack(
                                      children: [
                                        RawScrollbar(
                                          thickness: 10,
                                          controller:
                                              mainScrollController.value,
                                          radius: const Radius.circular(5),
                                          thumbVisibility: true,
                                          trackVisibility: true,
                                          child: ListView.builder(
                                            reverse: true,
                                            controller:
                                                mainScrollController.value,
                                            itemCount: socketio
                                                .findmyRoom(this)!
                                                .message
                                                .length,
                                            itemBuilder: (context, index) {
                                              return socketio
                                                  .findmyRoom(this)!
                                                  .message[socketio
                                                          .findmyRoom(this)!
                                                          .message
                                                          .length -
                                                      index -
                                                      1]
                                                  .chatfield();
                                            },
                                          ),
                                        ),
                                        Obx(
                                          () => socketio
                                                      .socketChatStatus.value ==
                                                  true
                                              ? Container()
                                              : Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade800,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "İnternet Bağlantısı Zayıf",
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .signal_cellular_connected_no_internet_0_bar_rounded,
                                                            color: Colors.red,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                          Obx(
                            () => socketio.isInRoom(this) != true
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MessageSendfield.field1(
                                        this,
                                        socketio.findmyRoomanyWhereGroup()!,
                                        chattextcontroller),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: showMembers.value,
                        child: socketio.findcurrentGroup(this).groupmembers ==
                                null
                            ? Container()
                            : Container(
                                color: const Color.fromARGB(255, 21, 21, 21),
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RawScrollbar(
                                    controller: membersScrollController.value,
                                    thickness: 5,
                                    scrollbarOrientation:
                                        ScrollbarOrientation.right,
                                    radius: const Radius.circular(5),
                                    child: ListView.builder(
                                      controller: membersScrollController.value,
                                      itemCount: socketio
                                          .findcurrentGroup(this)
                                          .groupmembers!
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => socketio
                                              .findcurrentGroup(this)
                                              .groupmembers![index]
                                              .listtile(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
