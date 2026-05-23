import 'package:flutter/material.dart';

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceElevated;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color textSubtle;
  final Color accent;
  final Color accentSoft;
  final Color destructive;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final List<BoxShadow> shadowSm;

  const AppThemeTokens({
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceElevated,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.accent,
    required this.accentSoft,
    required this.destructive,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.shadowSm,
  });

  static const light = AppThemeTokens(
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF1F5F9),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0xFFE2E8F0),
    text: Color(0xFF0F172A),
    textMuted: Color(0xFF64748B),
    textSubtle: Color(0xFF94A3B8),
    accent: Color(0xFFEF4444),
    accentSoft: Color(0xFFFFE4E6),
    destructive: Color(0xFFDC2626),
    radiusSm: 6,
    radiusMd: 8,
    radiusLg: 12,
    shadowSm: [
      BoxShadow(
        color: Color(0x140F172A),
        blurRadius: 14,
        offset: Offset(0, 8),
      ),
    ],
  );

  static const dark = AppThemeTokens(
    surface: Color(0xFF111827),
    surfaceMuted: Color(0xFF1F2937),
    surfaceElevated: Color(0xFF18202D),
    border: Color(0xFF263244),
    text: Color(0xFFF8FAFC),
    textMuted: Color(0xFFCBD5E1),
    textSubtle: Color(0xFF94A3B8),
    accent: Color(0xFFF87171),
    accentSoft: Color(0xFF3B1F26),
    destructive: Color(0xFFF87171),
    radiusSm: 6,
    radiusMd: 8,
    radiusLg: 12,
    shadowSm: [
      BoxShadow(
        color: Color(0x66000000),
        blurRadius: 16,
        offset: Offset(0, 10),
      ),
    ],
  );

  static AppThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<AppThemeTokens>() ??
        (Theme.of(context).brightness == Brightness.dark ? dark : light);
  }

  @override
  AppThemeTokens copyWith({
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceElevated,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? accent,
    Color? accentSoft,
    Color? destructive,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    List<BoxShadow>? shadowSm,
  }) {
    return AppThemeTokens(
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      destructive: destructive ?? this.destructive,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      shadowSm: shadowSm ?? this.shadowSm,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) {
      return this;
    }

    return AppThemeTokens(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      radiusSm: _lerpDouble(radiusSm, other.radiusSm, t),
      radiusMd: _lerpDouble(radiusMd, other.radiusMd, t),
      radiusLg: _lerpDouble(radiusLg, other.radiusLg, t),
      shadowSm: t < 0.5 ? shadowSm : other.shadowSm,
    );
  }
}

double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
