import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var usernameController = TextEditingController().obs;
  var userpasswordController = TextEditingController().obs;

  var loginprocess = false.obs;

  var isHoveredClose = false.obs;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  Future<void> login(String username, String password) async {
    if (loginprocess.value) {
      return;
    }

    loginprocess.value = true;
    LoginResponse response = await ARMOYU.service.authServices.login(
      username: username,
      password: password,
    );

    loginprocess.value = false;

    if (!response.result.status) {
      return;
    }

    if (response.result.description == "Oyuncu bilgileri yanlış!") {
      return;
    }

    ARMOYU.widget.accountController.changeUser(
      UserAccounts(
        user: User.apilogintoUser(response.response!).obs,
        sessionTOKEN: Rx(response.result.description),
        language: Rxn(),
      ),
    );

    AppList.sessions.add(
      Session(
        currentUser: Player(
          user: User.apilogintoUser(response.response!),
        ),
      ),
    );

    Get.offNamed("/home");
  }
}
