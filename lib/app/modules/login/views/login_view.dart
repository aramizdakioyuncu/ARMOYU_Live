import 'package:armoyu_desktop/app/modules/login/controllers/login_controller.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AppbarWidget.buildAppBar(),
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
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintText: "Kullanıcı Adı",
                        ),
                        controller: controller.usernameController.value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintText: "Parola",
                        ),
                        obscureText: true,
                        controller: controller.userpasswordController.value,
                      ),
                    ),
                    const Text("Versiyon 1.0.0.0"),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ARMOYU.widget.elevatedButton.costum1(
                          text: "Giriş",
                          onPressed: () {
                            controller.login(
                              controller.usernameController.value.text,
                              controller.userpasswordController.value.text,
                            );
                          },
                          loadingStatus: controller.loginprocess.value,
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: const Text("Giriş"),
                    // ),
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
