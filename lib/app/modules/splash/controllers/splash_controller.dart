import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 500), () {
      login();

      Get.toNamed("/home");
    });
  }

  void passSecurity() {
    login();
    Get.toNamed("/home");
  }

  void login() {
    AppList.sessions.add(
      Session(
        currentUser: User(
            id: 1,
            serialNumber: "",
            firstname: "Berkay",
            lastname: "Tikenoğlu",
            username: "berkaytikenoglu",
            displayname: "Berkay Tikenoğlu",
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
            )),
      ),
    );
  }
}
