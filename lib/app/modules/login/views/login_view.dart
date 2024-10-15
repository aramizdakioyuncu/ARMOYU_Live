import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/login/controllers/login_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
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
                  AppList.sessions.add(
                    Session(
                      currentUser: User(
                        id: 1,
                        serialNumber: "",
                        firstname: "Berkay",
                        lastname: "Tikenoğlu",
                        username: controller.usernameController.value.text,
                        displayname: controller.usernameController.value.text,
                        phonenumber: "5370585150",
                        email: "berkaytikenoglu@gmail.com",
                        gender: Gender.male,
                        avatar: Media(
                          id: 1,
                          type: MediaType.image,
                          bigUrl:
                              "https://media.licdn.com/dms/image/v2/D4D03AQFjLf2jWHCOpg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1705836999423?e=2147483647&v=beta&t=J-lf3atRxbDoO0xEkvB1gy8gw7A91TNKnPIxserZir0",
                          normalUrl:
                              "https://media.licdn.com/dms/image/v2/D4D03AQFjLf2jWHCOpg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1705836999423?e=2147483647&v=beta&t=J-lf3atRxbDoO0xEkvB1gy8gw7A91TNKnPIxserZir0",
                          minUrl:
                              "https://media.licdn.com/dms/image/v2/D4D03AQFjLf2jWHCOpg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1705836999423?e=2147483647&v=beta&t=J-lf3atRxbDoO0xEkvB1gy8gw7A91TNKnPIxserZir0",
                          isLocal: false,
                        ),
                      ),
                    ),
                  );

                  Get.offNamed("/home");
                },
                child: const Text("Giriş"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
