import 'package:armoyu_desktop/app/theme/app_theme_tokens.dart';
import 'package:armoyu_desktop/app/widgets/ui/app_ui.dart';
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
    final tokens = AppThemeTokens.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        border: Border.all(
          color: _focused ? tokens.accent : tokens.border,
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
                style: TextStyle(
                  color: tokens.text,
                  fontSize: 13,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mesaj gönder...",
                  hintStyle: TextStyle(
                    color: tokens.textSubtle,
                    fontSize: 13,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
  @override
  Widget build(BuildContext context) {
    return AppIconAction(
      icon: widget.icon,
      onTap: widget.onTap,
      color: widget.color,
      size: 34,
      iconSize: 18,
    );
  }
}
