import 'package:armoyu_desktop/app/theme/app_theme_tokens.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class AppPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool elevated;
  final bool border;
  final Color? color;
  final double? radius;

  const AppPanel({
    super.key,
    required this.child,
    this.padding,
    this.elevated = false,
    this.border = true,
    this.color,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (elevated ? tokens.surfaceElevated : tokens.surface),
        borderRadius: BorderRadius.circular(radius ?? tokens.radiusMd),
        border: border ? Border.all(color: tokens.border) : null,
        boxShadow: elevated ? tokens.shadowSm : null,
      ),
      child: child,
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool expanded;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final colors = _buttonColors(tokens);

    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.foreground,
            ),
          )
        else if (icon != null)
          Icon(icon, size: 16),
        if (icon != null || isLoading) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return SizedBox(
      width: expanded ? double.infinity : null,
      height: 38,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.background.withValues(alpha: 0.45);
            }
            if (states.contains(WidgetState.hovered)) {
              return colors.hoverBackground;
            }
            return colors.background;
          }),
          foregroundColor: WidgetStatePropertyAll(colors.foreground),
          overlayColor: WidgetStatePropertyAll(
            colors.foreground.withValues(alpha: 0.08),
          ),
          side: WidgetStatePropertyAll(
            colors.border == null
                ? BorderSide.none
                : BorderSide(color: colors.border!),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        child: child,
      ),
    );
  }

  _ButtonColors _buttonColors(AppThemeTokens tokens) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonColors(
          background: tokens.accent,
          hoverBackground: tokens.accent.withValues(alpha: 0.88),
          foreground: Colors.white,
        );
      case AppButtonVariant.secondary:
        return _ButtonColors(
          background: tokens.surfaceMuted,
          hoverBackground: tokens.text.withValues(alpha: 0.10),
          foreground: tokens.text,
          border: tokens.border,
        );
      case AppButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          hoverBackground: tokens.text.withValues(alpha: 0.08),
          foreground: tokens.textMuted,
        );
      case AppButtonVariant.danger:
        return _ButtonColors(
          background: tokens.destructive,
          hoverBackground: tokens.destructive.withValues(alpha: 0.88),
          foreground: Colors.white,
        );
    }
  }
}

class AppIconAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool active;
  final Color? color;
  final Color? activeColor;
  final double size;
  final double iconSize;

  const AppIconAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.active = false,
    this.color,
    this.activeColor,
    this.size = 32,
    this.iconSize = 18,
  });

  @override
  State<AppIconAction> createState() => _AppIconActionState();
}

class _AppIconActionState extends State<AppIconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final iconColor = widget.active
        ? (widget.activeColor ?? tokens.accent)
        : (widget.color ?? (_hovered ? tokens.text : tokens.textMuted));

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _hovered
                ? tokens.text.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(tokens.radiusSm),
          ),
          child: Icon(widget.icon, size: widget.iconSize, color: iconColor),
        ),
      ),
    );

    if (widget.tooltip == null) {
      return button;
    }

    return Tooltip(message: widget.tooltip!, child: button);
  }
}

class AppSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AppSearchField({
    super.key,
    this.hintText = 'Ara',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return AppPanel(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: tokens.surfaceMuted,
      radius: tokens.radiusSm,
      child: Row(
        children: [
          Icon(Icons.search, size: 14, color: tokens.textSubtle),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: tokens.text, fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: tokens.textSubtle, fontSize: 12),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppSectionLabel extends StatelessWidget {
  final String label;
  final Widget? trailing;

  const AppSectionLabel({
    super.key,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: tokens.textSubtle,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ButtonColors {
  final Color background;
  final Color hoverBackground;
  final Color foreground;
  final Color? border;

  const _ButtonColors({
    required this.background,
    required this.hoverBackground,
    required this.foreground,
    this.border,
  });
}
