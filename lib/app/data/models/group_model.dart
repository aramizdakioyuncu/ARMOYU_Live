import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_desktop/app/widgets/message_sendfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Group {
  final int groupID;
  final String name;
  final String description;
  final Media logo;
  final List<Groupmember> groupmembers;
  final List<Room> rooms;

  Group({
    required this.groupID,
    required this.name,
    required this.description,
    required this.logo,
    required this.groupmembers,
    required this.rooms,
  });

  Widget pageDetail(BuildContext context) {
    final mainScrollController = ScrollController();
    final membersScrollController = ScrollController();
    var showMembers = false.obs;

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
                  trailing: const Icon(Icons.sensor_occupied_rounded),
                ),
              ),
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
              ...List.generate(
                rooms.length,
                (index) {
                  return rooms[index].roomfield();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ExpansionTile(
                  title: const Text(
                    "Voice Channels",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.keyboard_voice_sharp),
                      title: const Text("sesli sohbet ODASI"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.keyboard_voice_sharp),
                      title: const Text("sesli sohbet  2"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.keyboard_voice_sharp),
                      title: const Text("sesli sohbet ODASI"),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Bottomusermenu.field(AppList.sessions[0].currentUser),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.tag,
                    color: Colors.grey,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text("yazılı metinodası"),
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
                    child: TextField(
                      style: TextStyle(fontSize: 11),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: RawScrollbar(
                                thickness: 10,
                                controller: mainScrollController,
                                radius: const Radius.circular(5),
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: ListView.builder(
                                  controller: mainScrollController,
                                  itemCount: rooms[0].message!.length,
                                  itemBuilder: (context, index) {
                                    return rooms[0].message![index].chatfield();
                                  },
                                ),
                              ),
                            ),
                            MessageSendfield.field1(),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: showMembers.value,
                        child: Container(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RawScrollbar(
                              controller: membersScrollController,
                              thickness: 5,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              radius: const Radius.circular(5),
                              child: ListView.builder(
                                controller: membersScrollController,
                                itemCount:
                                    AppList.groups[0].groupmembers.length,
                                itemBuilder: (context, index) {
                                  return AppList.groups[0].groupmembers[index]
                                      .listtile();
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
