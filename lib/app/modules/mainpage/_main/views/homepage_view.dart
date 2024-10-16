import 'package:armoyu_desktop/app/modules/mainpage/events/views/events_view.dart';
import 'package:armoyu_desktop/app/modules/mainpage/friends/views/friends_view.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    var homeSelectedPage = 0.obs;
    var pageviewController = PageController().obs;

    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Material(
            color: const Color.fromARGB(255, 29, 29, 29),
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        homeSelectedPage.value = 0;
                        pageviewController.value.jumpToPage(0);
                      },
                      selected: homeSelectedPage.value == 0 ? true : false,
                      leading: const Icon(
                        Icons.gamepad,
                      ),
                      title: const Text("Etkinlik"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        homeSelectedPage.value = 1;
                        pageviewController.value.jumpToPage(1);
                      },
                      selected: homeSelectedPage.value == 1 ? true : false,
                      leading: const Icon(
                        Icons.book_sharp,
                      ),
                      title: const Text("Kitaplık"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        homeSelectedPage.value = 2;
                        pageviewController.value.jumpToPage(2);
                      },
                      selected: homeSelectedPage.value == 2 ? true : false,
                      leading: const Icon(
                        Icons.speed,
                      ),
                      title: const Text("Turbo"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        homeSelectedPage.value = 3;
                        pageviewController.value.jumpToPage(3);
                      },
                      selected: homeSelectedPage.value == 3 ? true : false,
                      leading: const Icon(
                        Icons.group,
                      ),
                      title: const Text("Arkadaşlar"),
                    ),
                  ),
                  const Spacer(),
                  Bottomusermenu.field(
                      AppList.sessions.first.currentUser, null),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: pageviewController.value,
            onPageChanged: (value) {
              homeSelectedPage.value = value;
            },
            children: const [
              EventsView(),
              FriendsView(),
            ],
          ),
        ),
      ],
    );
  }
}
