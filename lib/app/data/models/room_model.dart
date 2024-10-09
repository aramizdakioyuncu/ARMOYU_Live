import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:flutter/material.dart';

class Room {
  final String name;
  final int limit;
  final RoomType type;
  final List<Message>? message;

  Room({
    required this.name,
    required this.limit,
    required this.type,
    this.message,
  });

  Widget roomfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: () {},
        leading: Icon(
          type == RoomType.text ? Icons.tag : Icons.multitrack_audio_rounded,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

enum RoomType { voice, text }
