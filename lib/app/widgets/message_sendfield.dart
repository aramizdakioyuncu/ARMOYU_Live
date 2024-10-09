import 'package:flutter/material.dart';

class MessageSendfield {
  static Widget field1() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_rounded,
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                style: TextStyle(
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.card_giftcard,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.gif,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
