import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/session_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';

class AppList {
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
              message: "sa",
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
              message: "as",
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
          name: "Enginin götünü tartışma odası",
          limit: 1,
          type: RoomType.voice,
        ),
        Room(
          name: "chat",
          limit: 1,
          type: RoomType.text,
        ),
      ],
      groupmembers: [
        Groupmember(
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
          description: "Sex on THE beach!",
          status: 1,
        ),
        Groupmember(
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
          description: "Metin2 oynuyor",
          status: 1,
        ),
        Groupmember(
          user: User(
            displayname: "berkaytikenoglu",
            avatar: Media(
              id: 3,
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
          description: "Spintires oynuyor",
          status: 1,
        ),
        Groupmember(
          user: User(
            displayname: "Oguzhan",
            avatar: Media(
              id: 4,
              type: MediaType.image,
              bigUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              normalUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              minUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              isLocal: false,
            ),
          ),
          description: "Visual Studio oynuyor",
          status: 1,
        ),
      ],
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
          name: "Enginin götünü tartışma odası",
          limit: 1,
          type: RoomType.voice,
        ),
        Room(
          name: "chat",
          limit: 1,
          type: RoomType.text,
        ),
      ],
      groupmembers: [
        Groupmember(
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
          description: "Sex on THE beach!",
          status: 1,
        ),
        Groupmember(
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
          description: "Metin2 oynuyor",
          status: 1,
        ),
        Groupmember(
          user: User(
            displayname: "berkaytikenoglu",
            avatar: Media(
              id: 3,
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
          description: "Spintires oynuyor",
          status: 1,
        ),
        Groupmember(
          user: User(
            displayname: "Oguzhan",
            avatar: Media(
              id: 4,
              type: MediaType.image,
              bigUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              normalUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              minUrl:
                  "https://media.licdn.com/dms/image/v2/D4D03AQGh-3rIi_slRg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1715102140530?e=2147483647&v=beta&t=7DtjPU3mush5YhAbu_F8OHaFLo5TEf-W-YjFcYRuUIM",
              isLocal: false,
            ),
          ),
          description: "Visual Studio oynuyor",
          status: 1,
        ),
      ],
    ),
  ];
}
