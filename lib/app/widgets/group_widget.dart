import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/modules/home/_main/controllers/home_controller.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_desktop/app/widgets/group_member_widget.dart';
import 'package:armoyu_desktop/app/widgets/message_sendfield.dart';
import 'package:armoyu_desktop/app/widgets/message_widget.dart';
import 'package:armoyu_desktop/app/widgets/room_create_widget.dart';
import 'package:armoyu_desktop/app/widgets/room_widget.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';

class GroupWidget {
  static Widget pageDetail(BuildContext context, Group group) {
    var mainScrollController = ScrollController().obs;
    var membersScrollController = ScrollController().obs;

    final socketio = Get.find<SocketioControllerV2>();

    var chattextcontroller = TextEditingController().obs;

    // micinit();

    final homeController = Get.put(HomeController());

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
                  title: Text(
                    group.name,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  onTap: () {},
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert), // 3 noktalı ikon
                    onSelected: (String value) {
                      if (value == "takviye") {
                        Get.toNamed("/turbo", parameters: {
                          "group": group.groupID.toString(),
                        });
                      }

                      if (value == "olustur") {
                        RoomCreateWidget.showAlertDialog(
                            context, group, socketio);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: "takviye",
                        child: Text("Sunucu Takviyesi"),
                      ),
                      const PopupMenuItem(
                        value: "davet",
                        child: Text("Arkadaşlarını Davet Et"),
                      ),
                      const PopupMenuItem(
                        value: "ayarlar",
                        child: Text("Sunucu Ayarları"),
                      ),
                      const PopupMenuItem(
                        value: "olustur",
                        child: Text("Kanal Oluştur"),
                      ),
                      const PopupMenuItem(
                        value: "kategori",
                        child: Text("Kategori Oluştur"),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    RoomCreateWidget.showAlertDialog(context, group, socketio);
                  },
                  child: ListView(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              group.logo.mediaURL.minURL.value,
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
                            socketio.findcurrentGroup(group).rooms!.length,
                            (index) {
                              return Obx(
                                () => RoomWidget.roomfield(
                                  group,
                                  socketio
                                      .findcurrentGroup(group)
                                      .rooms![index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Bottomusermenu.field(AppList.sessions.first.currentUser),
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
                    () => socketio.isInRoom(group) != true
                        ? Container()
                        : Icon(
                            socketio.findmyRoom(group)!.type == RoomType.text
                                ? Icons.tag
                                : Icons.volume_up,
                            color: Colors.grey,
                            size: 25,
                          ),
                  ),
                  const SizedBox(width: 5),
                  Obx(
                    () => Text(
                      socketio.isInRoom(group) != true
                          ? group.name
                          : socketio.findmyRoom(group)!.name.toString(),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // socketio.startListening();
                    },
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
                        homeController.showMembers.value =
                            !homeController.showMembers.value;
                      },
                      icon: Icon(
                        Icons.group,
                        color: homeController.showMembers.value == true
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
                    Obx(
                      () => socketio.isInRoom(group) != true
                          ? Expanded(child: Container())
                          : Expanded(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Obx(
                                                () => Container(
                                                  height: 200,
                                                  width: 300,
                                                  color: homeController
                                                              .connectionState
                                                              .value ==
                                                          webrtc
                                                              .RTCPeerConnectionState
                                                              .RTCPeerConnectionStateConnected
                                                      ? null
                                                      : Colors.black,
                                                  child: webrtc.RTCVideoView(
                                                    homeController
                                                        .localRenderer.value,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Obx(
                                                () => Wrap(
                                                  children: List.generate(
                                                    homeController
                                                        .remoteRenderers.length,
                                                    (index) {
                                                      return Container(
                                                        height: 200,
                                                        width: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child:
                                                            webrtc.RTCVideoView(
                                                          homeController
                                                                  .remoteRenderers[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Eskisi
                                      // SizedBox(
                                      //   height: 300,
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     children: [
                                      //       Expanded(
                                      //         flex: 1,
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(8.0),
                                      //           child: Obx(
                                      //             () => Container(
                                      //               height: 200,
                                      //               color: homeController
                                      //                           .connectionState
                                      //                           .value ==
                                      //                       webrtc
                                      //                           .RTCPeerConnectionState
                                      //                           .RTCPeerConnectionStateConnected
                                      //                   ? null
                                      //                   : Colors.black,
                                      //               child: webrtc.RTCVideoView(
                                      //                 homeController
                                      //                     .localRenderer.value,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       // Uzak video
                                      //       Expanded(
                                      //         flex: 1,
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(8.0),
                                      //           child: Obx(
                                      //             () => Container(
                                      //               height: 200,
                                      //               color: homeController
                                      //                           .connectionState
                                      //                           .value ==
                                      //                       webrtc
                                      //                           .RTCPeerConnectionState
                                      //                           .RTCPeerConnectionStateConnected
                                      //                   ? null
                                      //                   : Colors.black,
                                      //               child: webrtc.RTCVideoView(
                                      //                 homeController
                                      //                     .remoteRenderer.value,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Positioned(
                                        bottom: 0, // Alt kısma yerleştiriyoruz
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.screen_share_rounded),
                                                style: const ButtonStyle(
                                                  iconColor:
                                                      WidgetStatePropertyAll(
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                onPressed: () {
                                                  socketio.micOnOff(
                                                    AppList.sessions.first
                                                        .currentUser,
                                                  );
                                                },
                                                style: AppList
                                                            .sessions
                                                            .first
                                                            .currentUser
                                                            .microphone
                                                            .value ==
                                                        true
                                                    ? const ButtonStyle(
                                                        iconColor:
                                                            WidgetStatePropertyAll(
                                                          Colors.black,
                                                        ),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                          Colors.white,
                                                        ),
                                                      )
                                                    : const ButtonStyle(
                                                        iconColor:
                                                            WidgetStatePropertyAll(
                                                          Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                          Colors.red,
                                                        ),
                                                      ),
                                                icon: const Icon(Icons.mic_off),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                onPressed: () {
                                                  socketio.changeroom(null);
                                                },
                                                style: const ButtonStyle(
                                                  iconColor:
                                                      WidgetStatePropertyAll(
                                                    Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                    Colors.red,
                                                  ),
                                                ),
                                                icon:
                                                    const Icon(Icons.call_end),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Expanded(
                                      child: socketio.isInRoom(group) != true
                                          ? Container()
                                          : Stack(
                                              children: [
                                                RawScrollbar(
                                                  thickness: 10,
                                                  controller:
                                                      mainScrollController
                                                          .value,
                                                  radius:
                                                      const Radius.circular(5),
                                                  thumbVisibility: true,
                                                  trackVisibility: true,
                                                  child: ListView.builder(
                                                    reverse: true,
                                                    controller:
                                                        mainScrollController
                                                            .value,
                                                    itemCount: socketio
                                                        .findmyRoom(group)!
                                                        .message
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return MessageWidget
                                                          .chatfield(
                                                        socketio
                                                            .findmyRoom(group)!
                                                            .message[socketio
                                                                .findmyRoom(
                                                                    group)!
                                                                .message
                                                                .length -
                                                            index -
                                                            1],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Obx(
                                                  () => socketio
                                                              .socketChatStatus
                                                              .value ==
                                                          true
                                                      ? Container()
                                                      : Align(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade800,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  5,
                                                                ),
                                                              ),
                                                              child: const Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    "İnternet Bağlantısı Zayıf",
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .signal_cellular_connected_no_internet_0_bar_rounded,
                                                                    color: Colors
                                                                        .red,
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
                                    () => socketio.isInRoom(group) != true
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MessageSendfield.field1(
                                              chattextcontroller:
                                                  chattextcontroller,
                                              onsubmitted: (value) {
                                                socketio.sendMessage(
                                                    value,
                                                    socketio
                                                        .findmyRoomanyWhereGroup()!);
                                                chattextcontroller.value
                                                    .clear();
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: homeController.showMembers.value,
                        child: socketio.findcurrentGroup(group).groupmembers ==
                                null
                            ? Container()
                            : Container(
                                color: const Color.fromARGB(255, 21, 21, 21),
                                width: 250,
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
                                          .findcurrentGroup(group)
                                          .groupmembers!
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Obx(() {
                                          return GroupMemberWidget.listtile(
                                            socketio
                                                .findcurrentGroup(group)
                                                .groupmembers![index],
                                          );
                                        });
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
