import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/settingslist_model.dart';
import 'package:armoyu_desktop/app/modules/settings/accounts/views/settings_account_view.dart';
import 'package:armoyu_desktop/app/modules/settings/security/views/security_view.dart';
import 'package:get/get.dart';

class AppList {
  static List<SettingsList> settingsList = [
    SettingsList(
        title: "Hesabım",
        description: "Kullanıcı Hesap ayarları",
        route: "account",
        page: const SettingsAccountView()),
    SettingsList(
      title: "Gizlilik ve Güvenlik",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
      page: const SettingsSecurityView(),
    ),
    SettingsList(
      title: "Yetkili Uygulamalar",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Bağlantılar",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Faturalandırma",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "ARMOYU Turbo",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "HypeSquad",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Ses ve Görüntü",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Arayüz",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Bildirimler",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Tuş Atamaları",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Oyun Aktivitileri",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Activity Feed",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Oyun Kütüphanesi",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Metin ve Resimler",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Görünüm",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Yayıncı Modu",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Dil",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Windows/Mac/Linux Ayarları",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
    SettingsList(
      title: "Değişim Kaydı",
      description: "Kullanıcı Hesap ayarları",
      route: "account",
    ),
  ];
  static List<Session> sessions = [];
  static RxList<Group> groups = <Group>[].obs;
}
