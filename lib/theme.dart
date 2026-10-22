import 'package:flutter/material.dart';

class GuideColors {
  static const ink = Color(0xFF17322D);
  static const green = Color(0xFF176B5B);
  static const greenDark = Color(0xFF10483E);
  static const mint = Color(0xFFE2F2EB);
  static const paper = Color(0xFFF5F7F4);
  static const orange = Color(0xFFF0A35A);
  static const muted = Color(0xFF687A74);
  static const line = Color(0xFFE1E8E2);
  static const warning = Color(0xFF8A4B0F);
  static const warningBg = Color(0xFFFFF1DB);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: GuideColors.green,
      brightness: Brightness.light,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: GuideColors.paper,
      appBarTheme: const AppBarThemeData(
        backgroundColor: GuideColors.paper,
        foregroundColor: GuideColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 34, height: 1.08, fontWeight: FontWeight.w800, color: GuideColors.ink, letterSpacing: -0.8),
        headlineMedium: TextStyle(fontSize: 26, height: 1.15, fontWeight: FontWeight.w800, color: GuideColors.ink, letterSpacing: -0.4),
        titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: GuideColors.ink),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: GuideColors.ink),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: GuideColors.ink),
        bodyMedium: TextStyle(fontSize: 13, height: 1.45, color: GuideColors.muted),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: GuideColors.line)),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: const TextStyle(color: GuideColors.muted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: GuideColors.line)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: GuideColors.line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: GuideColors.green, width: 1.5)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: GuideColors.mint,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontSize: 11, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: GuideColors.line)),
        selectedColor: GuideColors.mint,
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
    );
  }
}
