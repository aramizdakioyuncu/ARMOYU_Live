import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Message {
  final User user;
  final String message;
  final List<Media>? media;
  final DateTime datetime;

  Message({
    required this.user,
    required this.message,
    this.media,
    required this.datetime,
  });

  Widget chatfield() {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(
          user.avatar!.minUrl.toString(),
        ),
      ),
      title: Text(
        user.displayname.toString(),
      ),
      subtitle: Column(
        children: [
          Align(alignment: Alignment.bottomLeft, child: Text(message)),
          media == null
              ? Container()
              : Container(
                  color: Colors.black38,
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: media == null ? 0 : media!.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl:
                            "https://aramizdakioyuncu.com/galeri/profilresimleri/11357profilresimufaklik1668362839.webp",
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
