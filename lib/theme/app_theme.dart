import 'package:flutter/material.dart';

class AppTheme {
  // Modern dark UI colors (inspired by chat interfaces)
  static const Color background = Color(0xFF0D0D12);
  static const Color surfaceColor = Color(0xFF1A1A24);
  static const Color cardColor = Color(0xFF252535);
  static const Color accentBlue = Color(0xFF6C63FF);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);

  // Gradient for glassmorphism
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x50FFFFFF),
      Color(0x10FFFFFF),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF8B5CF6),
    ],
  );

  // Chat-style bubble gradient
  static const LinearGradient bubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
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
    return languageColors[language] ?? languageColors['Other'] ?? const Color(0xFF8E8E93);
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
      // Uses system font (SF Pro on iOS, Roboto on Android)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28, // Reduced from 34 for SE
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24, // Reduced from 28 for SE
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 20, // Reduced from 22 for SE
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 18, // Reduced from 20 for SE
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16, // Reduced from 17 for SE
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14, // Reduced from 15 for SE
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, // Reduced from 17 for SE
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, // Reduced from 15 for SE
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12, // Reduced from 13 for SE
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 12, // Reduced from 13 for SE
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
