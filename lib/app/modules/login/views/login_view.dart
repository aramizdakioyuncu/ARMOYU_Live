import 'package:armoyu_desktop/app/modules/login/controllers/login_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    var isHoveredClose = false.obs;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                windowManager.startDragging();
              },
              child: Container(
                color: Colors.transparent,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.abc,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          "Sürüklenebilir Pencere",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 19,
                          ),
                          style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            windowManager.minimize();
                          },
                        ),
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          icon: const Icon(
                            Icons.crop_square,
                            color: Colors.white,
                            size: 16,
                          ),
                          style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            bool isMaximized =
                                await windowManager.isMaximized();
                            if (isMaximized) {
                              windowManager
                                  .unmaximize(); // Pencereyi normale döndür
                            } else {
                              windowManager
                                  .maximize(); // Pencereyi tam ekran yap
                            }
                          },
                        ),
                        MouseRegion(
                          onEnter: (_) {
                            isHoveredClose.value = true;
                          },
                          onExit: (_) {
                            isHoveredClose.value = false;
                          },
                          child: Obx(
                            () => IconButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  isHoveredClose.value
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                windowManager.close();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu64.png",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Kullanıcı Adı",
                        ),
                        controller: controller.usernameController.value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Parola",
                        ),
                        obscureText: true,
                        controller: controller.userpasswordController.value,
                      ),
                    ),
                    const Text("Versiyon 1.0.0.0"),
                    ElevatedButton(
                      onPressed: () {
                        controller.login(
                          controller.usernameController.value.text,
                          controller.userpasswordController.value.text,
                        );
                      },
                      child: const Text("Giriş"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
