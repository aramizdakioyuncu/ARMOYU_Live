import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageWidget {
  static Widget chatfield(Message message) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(
          message.user.value.user.avatar!.mediaURL.minURL.value.toString(),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.user.value.user.displayName!.value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            message.datetime.toString(),
            style: const TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
      subtitle: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(message.message.value),
          ),
          message.media == null
              ? Container()
              : Container(
                  color: Colors.black38,
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount:
                        message.media == null ? 0 : message.media!.length,
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
