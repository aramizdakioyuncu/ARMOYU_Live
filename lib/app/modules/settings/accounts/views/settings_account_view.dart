import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsAccountView extends StatelessWidget {
  const SettingsAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                            AppList.sessions.first.currentUser.user.avatar!
                                .mediaURL.minURL.value,
                          ),
                          radius: 50,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "KULLANICI ADI",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${AppList.sessions.first.currentUser.user.userName!.value} #${AppList.sessions.first.currentUser.user.userID}",
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "E-POSTA",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              AppList.sessions.first.currentUser.user
                                  .detailInfo!.value!.email
                                  .toString(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Düzenle",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            await ARMOYU.service.authServices.logOut();
                            Get.offAndToNamed("/login");
                          },
                          child: const Text(
                            "Çıkış",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "İKİ AŞAMALI DOĞRULAMA",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ARMOYU hesabını ekstra bir güvenlik sağlayın",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("İki Aşamalı Doğrulama Etkinleştir"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
