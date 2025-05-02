import 'package:armoyu_desktop/app/modules/home/explore/pages/social/controllers/social_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialView extends StatelessWidget {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialController());

    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: controller.widgetStory.widget.value,
          ),
          Expanded(
            child: controller.widgetposts.widget.value!,
          )
        ],
      ),
    );
  }
}
