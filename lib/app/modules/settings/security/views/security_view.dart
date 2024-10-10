import 'package:armoyu_desktop/app/modules/settings/security/controllers/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSecurityView extends StatelessWidget {
  const SettingsSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsSecurityController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("GÜVENLİ DİREKT MESAJLAŞMA"),
              const Text(
                "Sana gönderilen sakıncalı içeriğe sahip mesajları otomatik olarak tara ve sil.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    onTap: () {
                      controller.selectedIndex.value = 0;
                    },
                    tileColor: controller.selectedIndex.value == 0
                        ? Colors.green
                        : Colors.grey.shade800,
                    leading: Checkbox(
                      value: controller.selectedIndex.value == 0 ? true : false,
                      onChanged: (value) {
                        controller.selectedIndex.value = 0;
                      },
                    ),
                    title: Text(
                      "Beni güvende tut",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 0
                            ? Colors.white
                            : Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      "Herkesten gelen direkt mesajları tara",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    onTap: () {
                      controller.selectedIndex.value = 1;
                    },
                    tileColor: controller.selectedIndex.value == 1
                        ? Colors.amber
                        : Colors.grey.shade800,
                    leading: Checkbox(
                      value: controller.selectedIndex.value == 1 ? true : false,
                      onChanged: (value) {
                        controller.selectedIndex.value = 1;
                      },
                    ),
                    title: Text(
                      "Arkadaşlarım iyidir",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 1
                            ? Colors.white
                            : Colors.amber,
                      ),
                    ),
                    subtitle: Text(
                      "Arkadaşım olmadığı sürece herkesten gelen direkt mesajları tara",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    onTap: () {
                      controller.selectedIndex.value = 2;
                    },
                    tileColor: controller.selectedIndex.value == 2
                        ? Colors.red
                        : Colors.grey.shade800,
                    leading: Checkbox(
                      value: controller.selectedIndex.value == 2 ? true : false,
                      onChanged: (value) {
                        controller.selectedIndex.value = 2;
                      },
                    ),
                    title: Text(
                      "Tehlike içinde yaşıyorum",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 2
                            ? Colors.white
                            : Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      "Bunu kapat. Hiçbir şeyi tarama karanfık tarafa geç.",
                      style: TextStyle(
                        color: controller.selectedIndex.value == 2
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SUNUCU GİZLİLİK VARSAYILANLARI",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Sunucu üyelerinden gelen doğrudan mesajlara izin ver",
                ),
                subtitle: const Text(
                  "Bu ayar yeni bir gruba katıldığında uygulanır. Mevcut gruplarda geçmişe yönelik uygulanmaz",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Checkbox(
                  value: true,
                  onChanged: (value) => value,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const Text(
                "SENİ KİM ARKADAŞ OLARAK EKLEYEBİLİR",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text(
                  "Herkes",
                ),
                trailing: Checkbox(
                  value: true,
                  onChanged: (value) => value,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              ListTile(
                title: const Text(
                  "Arkadaşların Arkadaşları",
                ),
                trailing: Checkbox(
                  value: true,
                  onChanged: (value) => value,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              ListTile(
                title: const Text(
                  "Grup Üyeleri",
                ),
                trailing: Checkbox(
                  value: true,
                  onChanged: (value) => value,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
