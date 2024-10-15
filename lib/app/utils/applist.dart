import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/settingslist_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
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
  static List<Group> groups = [
    Group(
      groupID: 1,
      logo: Media(
        id: 1,
        type: MediaType.image,
        bigUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQFHdXQAFtbcvJ_VPNceUnHZFMyj2jAb0c8A&s",
        normalUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQFHdXQAFtbcvJ_VPNceUnHZFMyj2jAb0c8A&s",
        minUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQFHdXQAFtbcvJ_VPNceUnHZFMyj2jAb0c8A&s",
        isLocal: false,
      ),
      name: "Gruplarsa",
      description: "masdçdçaks",
      rooms: <Room>[
        Room(
          name: "Sesli Oda",
          limit: 1,
          type: RoomType.voice,
        ),
        Room(
          name: "chat",
          limit: 1,
          type: RoomType.text,
        ),
      ].obs,
    ),
    Group(
      groupID: 1,
      logo: Media(
        id: 1,
        type: MediaType.image,
        bigUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDtoIAiZC5QTHvKawK5E5pRexfBUEKiJQoIA&s",
        normalUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDtoIAiZC5QTHvKawK5E5pRexfBUEKiJQoIA&s",
        minUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDtoIAiZC5QTHvKawK5E5pRexfBUEKiJQoIA&s",
        isLocal: false,
      ),
      name: "Gta V Online",
      description: "masdçdçaks",
      rooms: [
        Room(
          name: "Sesli Oda",
          limit: 1,
          type: RoomType.voice,
          message: [
            Message(
              user: User(
                displayname: "SirEscanor ",
                avatar: Media(
                  id: 2,
                  type: MediaType.image,
                  bigUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  normalUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  minUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  isLocal: false,
                ),
              ),
              message: "Gta dan anlayan var mı",
              datetime: DateTime(2024, 10, 09),
            ),
            Message(
              user: User(
                displayname: "Engin Kuşko",
                avatar: Media(
                  id: 1,
                  type: MediaType.image,
                  bigUrl:
                      "https://aramizdakioyuncu.com/galeri/profilresimleri/10915profilresimufaklik1714429566.jpg",
                  normalUrl:
                      "https://aramizdakioyuncu.com/galeri/profilresimleri/10915profilresimufaklik1714429566.jpg",
                  minUrl:
                      "https://aramizdakioyuncu.com/galeri/profilresimleri/10915profilresimufaklik1714429566.jpg",
                  isLocal: false,
                ),
              ),
              message: "alllls",
              media: [
                Media(
                  id: 1,
                  type: MediaType.image,
                  bigUrl: "bigUrl",
                  normalUrl: "normalUrl",
                  minUrl: "minUrl",
                  isLocal: false,
                )
              ],
              datetime: DateTime(2024, 10, 09),
            ),
            Message(
              user: User(
                displayname: "SirEscanor ",
                avatar: Media(
                  id: 2,
                  type: MediaType.image,
                  bigUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  normalUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  minUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  isLocal: false,
                ),
              ),
              message: "la",
              datetime: DateTime(2024, 10, 09),
            ),
            Message(
              user: User(
                displayname: "SirEscanor ",
                avatar: Media(
                  id: 2,
                  type: MediaType.image,
                  bigUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  normalUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  minUrl:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-F_IUA74KH0J4nq228jqYfMBuBh4NFO1AA&s",
                  isLocal: false,
                ),
              ),
              message: "ka",
              datetime: DateTime(2024, 10, 09),
            ),
          ],
        ),
        Room(
          name: "Sohbet odası",
          limit: 1,
          type: RoomType.voice,
        ),
        Room(
          name: "chat",
          limit: 1,
          type: RoomType.text,
        ),
      ].obs,
    ),
  ];
}
