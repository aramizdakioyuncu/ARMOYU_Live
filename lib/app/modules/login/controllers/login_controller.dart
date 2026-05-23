import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var usernameController = TextEditingController().obs;
  var userpasswordController = TextEditingController().obs;

  var loginprocess = false.obs;
  var isPasswordVisible = false.obs;
  var rememberPassword = false.obs;
  var loginErrorMessage = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    _loadRememberedCredentials();
  }

  @override
  void onClose() {
    usernameController.value.dispose();
    userpasswordController.value.dispose();
    super.onClose();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    rememberPassword.value = prefs.getBool('login_remember_password') ?? false;

    if (!rememberPassword.value) {
      return;
    }

    final rememberedUsername = prefs.getString('login_username');
    final rememberedPassword = prefs.getString('login_password');

    if (rememberedUsername != null) {
      usernameController.value.text = rememberedUsername;
    }

    if (rememberedPassword != null) {
      userpasswordController.value.text = rememberedPassword;
    }
  }

  Future<void> _saveRememberedCredentials({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('login_remember_password', rememberPassword.value);
    await prefs.setString('login_username', username);

    if (rememberPassword.value) {
      await prefs.setString('login_password', password);
      return;
    }

    await prefs.remove('login_password');
  }

  Future<void> login(String username, String password) async {
    if (loginprocess.value) {
      return;
    }

    loginErrorMessage.value = null;
    loginprocess.value = true;
    late LoginResponse response;
    try {
      response = await ARMOYU.service.authServices.login(
        username: username,
        password: password,
      );
    } catch (_) {
      loginErrorMessage.value = "Sunucuya bağlanılamadı.";
      loginprocess.value = false;
      return;
    }
    loginprocess.value = false;

    if (!response.result.status) {
      loginErrorMessage.value = response.result.description.isNotEmpty
          ? response.result.description
          : "Giriş başarısız oldu.";
      return;
    }

    if (response.result.description == "Oyuncu bilgileri yanlış!") {
      loginErrorMessage.value = "Şifre yanlış girildi.";
      return;
    }

    if (response.response == null) {
      loginErrorMessage.value = "Kullanıcı bilgileri alınamadı.";
      return;
    }

    await _saveRememberedCredentials(username: username, password: password);
    loginErrorMessage.value = null;

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
