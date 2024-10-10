import 'package:armoyu_desktop/app/modules/settings/_main/controllers/settings_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            const Spacer(),
            SizedBox(
              width: 290,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RawScrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  controller: controller.controller.value,
                  child: ListView.builder(
                    controller: controller.controller.value,
                    itemCount: AppList.settingsList.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => ListTile(
                          title: Text(AppList.settingsList[index].title),
                          selected: controller.selectedItem.value == index,
                          onTap: () {
                            controller.selectedItem.value = index;
                            controller.changepage();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 500,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            AppList.settingsList[controller.selectedItem.value]
                                .title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade800,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.grey.shade700,
                                  size: 20,
                                ),
                              ),
                            ),
                            Text(
                              "ESC",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller.pagecontroller.value,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (value) {
                        controller.selectedItem.value = value;
                      },
                      children: [
                        AppList.settingsList[0].page,
                        AppList.settingsList[1].page,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
