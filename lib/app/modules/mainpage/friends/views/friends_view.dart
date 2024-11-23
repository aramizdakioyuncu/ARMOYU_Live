import 'package:armoyu_desktop/app/modules/mainpage/friends/controllers/friends_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedMenuItem = 0.obs;

    final controller = Get.put(FriendsController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Obx(
                    () => SizedBox(
                      width: 160,
                      child: ListTile(
                        selected: selectedMenuItem.value == 0 ? true : false,
                        onTap: () {
                          selectedMenuItem.value = 0;
                        },
                        title: const Text(
                          "Arkadaş Ekle",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 160,
                      child: ListTile(
                        selected: selectedMenuItem.value == 1 ? true : false,
                        onTap: () {
                          selectedMenuItem.value = 1;
                        },
                        title: const Text(
                          "Tümü",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 160,
                      child: ListTile(
                        selected: selectedMenuItem.value == 2 ? true : false,
                        onTap: () {
                          selectedMenuItem.value = 2;
                        },
                        title: const Text(
                          "Çevrimiçi",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 160,
                      child: ListTile(
                        selected: selectedMenuItem.value == 3 ? true : false,
                        onTap: () {
                          selectedMenuItem.value = 3;
                        },
                        title: const Text(
                          "Bekleyen",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 160,
                      child: ListTile(
                        selected: selectedMenuItem.value == 4 ? true : false,
                        onTap: () {
                          selectedMenuItem.value = 4;
                        },
                        title: const Text(
                          "Engellenen",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("ARKADAŞ EKLE"),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Bir Arkadaşını ARMOYU Etiketi ile ekleyebilirsin.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Arkadaşlık İsteği Gönder"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Expanded(
                        child: controller.friendlist.isEmpty
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : SingleChildScrollView(
                                controller: controller.scrollController.value,
                                child: Column(
                                  children: List.generate(
                                    controller.friendlist.length,
                                    (index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                            controller.friendlist[index].avatar!
                                                .minUrl,
                                          ),
                                        ),
                                        title: Text(
                                          controller
                                              .friendlist[index].displayname!,
                                        ),
                                        subtitle: Text(
                                          controller
                                              .friendlist[index].displayname!,
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.remove_circle_outline_sharp,
                                          ),
                                        ),
                                        onTap: () {},
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Obx(
                      () => controller.isLoadingMoreProccess.value
                          ? const SizedBox(
                              height: 100,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
