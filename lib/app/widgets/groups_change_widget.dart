import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsChangeWidget {
  static Widget groups(index,
      {required Function onTap, required Rx selectedPage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () async {
          await onTap();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                const SizedBox(width: 50),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    AppList.groups[index].logo.mediaURL.minURL.value,
                  ),
                ),
              ],
            ),
            Positioned(
              left: -3,
              child: Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: selectedPage.value - 1 == index
                      ? Colors.red
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
