import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/modules/home/_main/controllers/home_controller.dart';
import 'package:armoyu_desktop/app/modules/home/explore/views/explore_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/_main/views/mainpage_view.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:armoyu_desktop/app/widgets/group_widget.dart';
import 'package:armoyu_desktop/app/widgets/groups_change_widget.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppbarWidget.buildAppBar(
                actions: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 19,
                    ),
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await controller.selectMicrophone();
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 19,
                    ),
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await controller.createOffer();
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 19,
                    ),
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await controller.startScreenSharing();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 21, 21, 21),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: InkWell(
                                onTap: () {
                                  controller.pageController.jumpToPage(0);
                                  controller.selectedPage.value = 0;
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    "https://api.aramizdakioyuncu.com/galeri/ana-yapi/armoyu64.png",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Obx(
                                  () => Column(children: [
                                    ...List.generate(
                                      AppList.groups.length,
                                      (index) {
                                        return GroupsChangeWidget.groups(
                                          index,
                                          onTap: () async {
                                            //Grup değiştir

                                            final groupID =
                                                AppList.groups[index].groupID;

                                            controller.pageController
                                                .jumpToPage(index + 2);
                                            controller.selectedPage.value =
                                                index + 1;

                                            controller.socketio.fetchUserList(
                                              groupID: groupID,
                                            );

                                            GroupRoomsResponse response =
                                                await ARMOYU
                                                    .service.groupServices
                                                    .groupRoomsFetch(
                                              groupID: groupID,
                                            );
                                            AppList.groups[index].rooms!.value =
                                                [];
                                            for (GroupRoom element
                                                in response.response!) {
                                              AppList.groups[index].rooms!.add(
                                                Room(
                                                  groupID: groupID,
                                                  roomID: element.roomID,
                                                  name: element.name,
                                                  limit: element.limit,
                                                  type: element.type,
                                                ),
                                              );
                                            }
                                          },
                                          selectedPage: controller.selectedPage,
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          controller.showAlertDialog(
                                              context, controller.socketio);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              controller.showAlertDialog(
                                                  context, controller.socketio);

                                              log("sadasdsa");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    log("sad");
                                    controller.pageController.jumpToPage(1);
                                  },
                                  icon: const Icon(
                                    Icons.compass_calibration_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        return PageView(
                          controller: controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (value) {
                            controller.selectedPage.value = value;
                          },
                          children: [
                            const MainpageView(),
                            const ExploreView(),
                            ...List.generate(
                              AppList.groups.length,
                              (index) {
                                return GroupWidget.pageDetail(
                                  context,
                                  AppList.groups[index],
                                );
                              },
                            )
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () => controller.socketio.isCallingMe.value != true
                ? Container()
                : Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      height: 80,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    AppList.sessions.first.currentUser.user
                                        .avatar!.mediaURL.minURL.value,
                                  ),
                                  maxRadius: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(controller
                                    .socketio.whichuserisCallingMe.value),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: InkWell(
                                        onTap: () {
                                          controller.socketio.acceptcall(
                                            controller.socketio
                                                .whichuserisCallingMe.value,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: InkWell(
                                        onTap: () {
                                          controller.socketio.closecall(
                                            controller.socketio
                                                .whichuserisCallingMe.value,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 12,
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
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
