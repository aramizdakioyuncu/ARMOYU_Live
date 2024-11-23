import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class LoginController extends GetxController {
  var usernameController = TextEditingController().obs;
  var userpasswordController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    windowManager.center();
    windowManager.setSize(const Size(800, 600));

    windowManager.setTitle("Login Panel"); // Başlık ayarı

    windowManager.setResizable(true);
    windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  }

  Future<void> login(String username, String password) async {
    Map<String, dynamic> response =
        await ARMOYU.service.authServices.previuslogin(
      username: username,
      password: password,
    );

    if (response['durum'] == 0) {
      return;
    }
    if (response['aciklama'] == "Oyuncu bilgileri yanlış!") {
      return;
    }

    AppList.sessions.add(
      Session(
        currentUser: User(
          id: response['icerik']['playerID'],
          serialNumber: "",
          firstname: response['icerik']['firstName'],
          lastname: response['icerik']['lastName'],
          username: username,
          password: password,
          displayname: password,
          phonenumber: response['icerik']['phoneNumber'],
          email: response['icerik']['email'],
          gender: Gender.male,
          avatar: Media(
            id: 1,
            type: MediaType.image,
            bigUrl: response['icerik']['avatar']['media_bigURL'],
            normalUrl: response['icerik']['avatar']['media_URL'],
            minUrl: response['icerik']['avatar']['media_minURL'],
            isLocal: false,
          ),
        ),
      ),
    );

    Get.offNamed("/home");
  }
}
