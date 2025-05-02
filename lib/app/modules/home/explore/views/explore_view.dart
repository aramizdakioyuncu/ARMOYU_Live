import 'package:armoyu_desktop/app/modules/home/explore/controllers/explore_controller.dart';
import 'package:armoyu_desktop/app/modules/home/explore/pages/applications/views/applications_view.dart';
import 'package:armoyu_desktop/app/modules/home/explore/pages/servers/views/servers_view.dart';
import 'package:armoyu_desktop/app/modules/home/explore/pages/social/views/social_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExploreController());
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: const Color.fromARGB(255, 29, 29, 29),
            width: 250,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Keşfet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    selected: controller.currentPage.value == 0,
                    onTap: () {
                      controller.pageController.value.jumpToPage(0);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.apps_rounded),
                    ),
                    title: const Text("Uygulamalar"),
                  ),
                ),
                Obx(
                  () => ListTile(
                    selected: controller.currentPage.value == 1,
                    onTap: () {
                      controller.pageController.value.jumpToPage(1);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.groups_2_sharp),
                    ),
                    title: const Text("Sunucular"),
                  ),
                ),
                Obx(
                  () => ListTile(
                    selected: controller.currentPage.value == 2,
                    onTap: () {
                      controller.pageController.value.jumpToPage(2);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.webhook_rounded),
                    ),
                    title: const Text("Sosyal"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller.pageController.value,
              onPageChanged: (value) {
                controller.changePage(value);
              },
              children: const [
                ApplicationsView(),
                ServersView(),
                SocialView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
