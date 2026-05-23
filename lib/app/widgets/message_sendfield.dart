import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSendfield {
  static Widget field1({
    required Rx<TextEditingController> chattextcontroller,
    required Function(String value) onsubmitted,
  }) {
    return _SendField(
      chattextcontroller: chattextcontroller,
      onsubmitted: onsubmitted,
    );
  }
}

class _SendField extends StatefulWidget {
  final Rx<TextEditingController> chattextcontroller;
  final Function(String value) onsubmitted;

  const _SendField(
      {required this.chattextcontroller, required this.onsubmitted});

  @override
  State<_SendField> createState() => _SendFieldState();
}

class _SendFieldState extends State<_SendField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused ? const Color(0xFF3A3A3A) : const Color(0xFF252525),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ActionBtn(icon: Icons.add_circle_outline_rounded, onTap: () {}),
          const SizedBox(width: 2),
          Expanded(
            child: Focus(
              onFocusChange: (v) => setState(() => _focused = v),
              child: TextField(
                autofocus: true,
                controller: widget.chattextcontroller.value,
                onSubmitted: (value) {
                  widget.onsubmitted(value);
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mesaj gönder...",
                  hintStyle: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 13,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _ActionBtn(icon: Icons.card_giftcard_outlined, onTap: () {}),
          _ActionBtn(icon: Icons.gif_box_outlined, onTap: () {}),
          _ActionBtn(
            icon: Icons.emoji_emotions_outlined,
            color: Colors.amber,
            onTap: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, this.color, required this.onTap});

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF2A2A2A) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: _hovered
                ? (widget.color ?? Colors.white)
                : (widget.color ?? const Color(0xFF666666)),
          ),
        ),
      ),
    );
  }
}
