import 'package:armoyu_desktop/app/theme/app_theme_tokens.dart';
import 'package:flutter/material.dart';

final ThemeData appDarkThemeData = _buildTheme(
  brightness: Brightness.dark,
  tokens: AppThemeTokens.dark,
);

final ThemeData appLightThemeData = _buildTheme(
  brightness: Brightness.light,
  tokens: AppThemeTokens.light,
);

ThemeData _buildTheme({
  required Brightness brightness,
  required AppThemeTokens tokens,
}) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: tokens.accent,
    brightness: brightness,
    primary: tokens.accent,
    surface: tokens.surface,
    error: tokens.destructive,
  );

  final textTheme = (isDark ? ThemeData.dark() : ThemeData.light())
      .textTheme
      .apply(
        bodyColor: tokens.text,
        displayColor: tokens.text,
      )
      .copyWith(
        titleLarge: TextStyle(
          color: tokens.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: tokens.text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: tokens.text,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: tokens.text, fontSize: 13),
        bodySmall: TextStyle(color: tokens.textMuted, fontSize: 12),
      );

  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(tokens.radiusMd),
    borderSide: BorderSide(color: tokens.border),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    extensions: [tokens],
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: tokens.accent,
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
    cardColor: tokens.surfaceElevated,
    dividerColor: tokens.border,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    iconTheme: IconThemeData(color: tokens.textMuted, size: 20),
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.surface,
      foregroundColor: tokens.text,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: tokens.textMuted),
      titleTextStyle: TextStyle(
        color: tokens.text,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: tokens.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: tokens.accent.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white70,
        minimumSize: const Size(0, 38),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
        ),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tokens.accent,
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
        ),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: tokens.textMuted,
        hoverColor: tokens.text.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.surfaceMuted,
      hintStyle: TextStyle(color: tokens.textSubtle, fontSize: 13),
      labelStyle: TextStyle(color: tokens.textMuted, fontSize: 13),
      prefixIconColor: tokens.textSubtle,
      suffixIconColor: tokens.textSubtle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: outlineBorder,
      enabledBorder: outlineBorder,
      focusedBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: tokens.accent, width: 1.4),
      ),
      errorBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: tokens.destructive),
      ),
      focusedErrorBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: tokens.destructive, width: 1.4),
      ),
    ),
    cardTheme: CardThemeData(
      color: tokens.surfaceElevated,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        side: BorderSide(color: tokens.border),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: tokens.text,
      iconColor: tokens.textMuted,
      selectedColor: tokens.text,
      selectedTileColor: tokens.accentSoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
      dense: true,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? tokens.accent
            : tokens.textSubtle,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? tokens.accent.withValues(alpha: 0.30)
            : tokens.surfaceMuted,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(tokens.accent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? tokens.accent
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(Colors.white),
      side: BorderSide(color: tokens.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusSm),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: tokens.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusLg),
      ),
      titleTextStyle: TextStyle(
        color: tokens.text,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: TextStyle(color: tokens.textMuted, fontSize: 13),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: tokens.surfaceElevated,
      contentTextStyle: TextStyle(color: tokens.text),
      actionTextColor: tokens.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: tokens.border,
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: tokens.accent,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusLg),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: tokens.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        side: BorderSide(color: tokens.border),
      ),
      textStyle: TextStyle(color: tokens.text, fontSize: 13),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: tokens.text,
      unselectedLabelColor: tokens.textMuted,
      indicatorColor: tokens.accent,
      dividerColor: tokens.border,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: tokens.surface,
      selectedItemColor: tokens.accent,
      unselectedItemColor: tokens.textMuted,
      elevation: 0,
      selectedIconTheme: IconThemeData(color: tokens.accent),
      unselectedIconTheme: IconThemeData(color: tokens.textMuted),
    ),
  );
}
