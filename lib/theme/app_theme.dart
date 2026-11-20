import 'package:flutter/material.dart';

class AppTheme {
  // iOS 27 inspired colors
  static const Color background = Color(0xFF0A0A0F);
  static const Color surfaceColor = Color(0xFF1C1C1E);
  static const Color cardColor = Color(0xFF2C2C2E);
  static const Color accentBlue = Color(0xFF0A84FF);
  static const Color accentPurple = Color(0xFF5E5CE6);
  static const Color accentPink = Color(0xFFFF375F);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentGreen = Color(0xFF30D158);
  static const Color accentCyan = Color(0xFF64D2FF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF636366);

  // Gradient for glassmorphism
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40FFFFFF),
      Color(0x10FFFFFF),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentBlue,
      accentPurple,
    ],
  );

  // Language colors (matching GitHub/WakaTime style)
  static const Map<String, Color> languageColors = {
    'Python': Color(0xFF3572A5),
    'JavaScript': Color(0xFFF7DF1E),
    'TypeScript': Color(0xFF3178C6),
    'Rust': Color(0xFFDEA584),
    'Go': Color(0xFF00ADD8),
    'Java': Color(0xFFB07219),
    'C++': Color(0xFFF34B7D),
    'C': Color(0xFF555555),
    'Ruby': Color(0xFF701516),
    'Swift': Color(0xFFFA7343),
    'Kotlin': Color(0xFFA97BFF),
    'Dart': Color(0xFF00B4AB),
    'PHP': Color(0xFF4F5D95),
    'HTML': Color(0xFFE34C26),
    'CSS': Color(0xFF563D7C),
    'SCSS': Color(0xFFCC6699),
    'Vue': Color(0xFF41B883),
    'React': Color(0xFF61DAFB),
    'Svelte': Color(0xFFFF3E00),
    'Shell': Color(0xFF89E051),
    'Bash': Color(0xFF4EAA25),
    'JSON': Color(0xFF292929),
    'YAML': Color(0xFFCB171E),
    'Markdown': Color(0xFF083FA1),
    'SQL': Color(0xFFE38C00),
    'Other': Color(0xFF8E8E93),
  };

  static Color getLanguageColor(String language) {
    return languageColors[language] ?? languageColors['Other']!;
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentPurple,
        surface: surfaceColor,
        error: accentPink,
      ),
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }
}
