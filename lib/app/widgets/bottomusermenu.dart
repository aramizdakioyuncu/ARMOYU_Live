import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(User user) {
    return Container(
      color: const Color.fromARGB(255, 24, 24, 24),
      child: ListTile(
        minTileHeight: 0,
        leading: CircleAvatar(
          foregroundImage: CachedNetworkImageProvider(
            user.avatar!.minUrl.toString(),
          ),
        ),
        title: Text(
          user.username.toString(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          "#${user.id.toString()}",
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.mic,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.headphones,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed("/settings");
              },
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.settings,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
