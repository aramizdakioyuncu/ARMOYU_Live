import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedMenuItem = 0.obs;
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
                    Container(
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
                    )
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
