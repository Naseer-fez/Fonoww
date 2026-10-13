import 'package:flutter/material.dart';

/// AppTheme defines the visual design system for Campus Buddy.
/// Demonstrates:
/// - Custom Material 3 ColorScheme & ThemeData
/// - Consistent typography, border radii, and elevation styling
/// - Light and Dark theme configurations
class AppTheme {
  // Brand Color Palette (as specified in Design Requirements)
  static const Color primaryAccent = Color(0xFF7567E8);
  static const Color primaryDarkAccent = Color(0xFF8F83F7);

  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF22243A);
  static const Color lightTextSecondary = Color(0xFF85899B);

  static const Color darkBackground = Color(0xFF13141F);
  static const Color darkCard = Color(0xFF1E2030);
  static const Color darkCardBorder = Color(0xFF292C42);
  static const Color darkTextPrimary = Color(0xFFF1F3F9);
  static const Color darkTextSecondary = Color(0xFF969AB0);

  // Functional Pastel Accents
  static const Color successMint = Color(0xFF4EBA87);
  static const Color paleLavender = Color(0xFFEDE9FE);
  static const Color gentlePeach = Color(0xFFFFB088);
  static const Color softCoral = Color(0xFFFF6B6B);
  static const Color softSkyBlue = Color(0xFF64B5F6);

  // Card Border Radius standard
  static const double cardRadius = 20.0;

  // Subtle Card Shadow for Light Mode
  static List<BoxShadow> get lightCardShadow => [
        BoxShadow(
          color: const Color(0xFF1A1D36).withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  // Subtle Card Shadow for Dark Mode
  static List<BoxShadow> get darkCardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  /// Light Theme Definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        onPrimary: Colors.white,
        secondary: paleLavender,
        onSecondary: primaryAccent,
        surface: lightCard,
        onSurface: lightTextPrimary,
        error: softCoral,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(
            color: const Color(0xFFE4E7F0).withOpacity(0.6),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E4EC), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E4EC), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: softCoral, width: 1.5),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFFACB1C4), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primaryAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE4E7F0)),
        ),
        labelStyle: const TextStyle(
          color: lightTextPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEDEFF6),
        thickness: 1,
        space: 24,
      ),
    );
  }

  /// Dark Theme Definition
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryDarkAccent,
        onPrimary: Colors.white,
        secondary: Color(0xFF2C284D),
        onSecondary: primaryDarkAccent,
        surface: darkCard,
        onSurface: darkTextPrimary,
        error: softCoral,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(
            color: darkCardBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkCardBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkCardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryDarkAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: softCoral, width: 1.5),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF6B7088), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDarkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: primaryDarkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkCardBorder),
        ),
        labelStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: darkCardBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
