import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget {
  static void showProfileDialog(BuildContext context, {required Player user}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: SizedBox(
            width: 500,
            height: 800,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 500,
                      child: CachedNetworkImage(
                        imageUrl: user.user.avatar!.mediaURL.minURL.value,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        top: 15,
                        right: 15,
                        child: Row(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: const EdgeInsets.all(2),
                                minimumSize: const Size(0, 0),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.person_pin),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: const EdgeInsets.all(2),
                                minimumSize: const Size(0, 0),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.more_horiz_rounded),
                            ),
                          ],
                        )),
                    Positioned(
                      bottom: -40,
                      left: 20,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(
                          user.user.avatar!.mediaURL.minURL.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              user.user.displayName!.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              user.user.userName!.value,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.chat),
                                  SizedBox(width: 5),
                                  Text("Mesaj"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: DefaultTabController(
                          length: 4, // Sekme sayısı

                          child: Column(
                            children: [
                              const TabBar(
                                labelColor: Colors.blue,
                                indicatorColor: Colors.blue,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(text: "Hakkımda"),
                                  Tab(text: "Etkinlik"),
                                  Tab(text: "Arkadaşlar"),
                                  Tab(text: "Sunucular"),
                                ],
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Şu Tarihten beri Üye:"),
                                            const SizedBox(height: 5),
                                            const Text("18 Haz 2022"),
                                            const SizedBox(height: 15),
                                            const Text("Not"),
                                            const SizedBox(height: 5),
                                            TextField(
                                              decoration: InputDecoration(
                                                focusColor: Colors.amber,
                                                hoverColor: Colors.grey[800],
                                                fillColor: Colors.transparent,
                                                hintText: "Notunuzu Girin",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView(
                                        children: List.generate(
                                          10,
                                          (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: ListTile(
                                                  tileColor: Colors.grey[800],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  leading: CachedNetworkImage(
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl:
                                                        "https://w7.pngwing.com/pngs/325/113/png-transparent-euro-truck-simulator-2-american-truck-simulator-video-game-rough-truck-simulator-2-others-freight-transport-truck-mode-of-transport-thumbnail.png",
                                                  ),
                                                  title: const Text(
                                                    "Euro Truck Simulator 2",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.gamepad_outlined,
                                                        size: 10,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text("3 Gün Önce"),
                                                    ],
                                                  ),
                                                  trailing: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.more_horiz_rounded,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ListView(
                                        children: List.generate(
                                          10,
                                          (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: ListTile(
                                                  onTap: () {},
                                                  hoverColor:
                                                      Colors.grey.shade800,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  leading: const CircleAvatar(
                                                    foregroundImage:
                                                        CachedNetworkImageProvider(
                                                            "https://api.aramizdakioyuncu.com/galeri/profilresimleri/10954profilresimufaklik1652701456.jpg"),
                                                  ),
                                                  title: const Text(
                                                    "nero",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ListView(
                                        children: List.generate(
                                          10,
                                          (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 5,
                                                  ),
                                                  onTap: () {},
                                                  hoverColor:
                                                      Colors.grey.shade800,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://api.aramizdakioyuncu.com/galeri/profilresimleri/1profilresimufaklik1734874339.jpg",
                                                    ),
                                                  ),
                                                  title: const Text(
                                                    "ARMOYU Topluluk Sunucusu",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  subtitle:
                                                      const Text("mentiondata"),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }
}
