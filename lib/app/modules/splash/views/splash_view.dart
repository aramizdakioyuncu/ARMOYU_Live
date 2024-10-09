import 'package:armoyu_desktop/app/modules/splash/controllers/splash_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu64.png",
            ),
            ElevatedButton(
              onPressed: controller.passSecurity,
              child: const Text("Geç"),
            ),
          ],
        ),
      ),
    );
  }
}
