import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSendfield {
  static Widget field1({
    required Rx<TextEditingController> chattextcontroller,
    required Function(String value) onsubmitted,
  }) {
    var textcontroller = chattextcontroller;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 24, 24),
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
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                autofocus: true,
                controller: textcontroller.value,
                onSubmitted: (value) {
                  onsubmitted(value);
                },
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
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
