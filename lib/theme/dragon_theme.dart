import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dragon_colors.dart';

class DragonTheme {
  DragonTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: DragonColors.dragonPurple,
        onPrimary: DragonColors.textPrimary,
        secondary: DragonColors.dragonGold,
        onSecondary: DragonColors.deepVoid,
        surface: DragonColors.nightSurface,
        onSurface: DragonColors.textPrimary,
        onSurfaceVariant: DragonColors.textSecondary,
        error: DragonColors.fireOrange,
        onError: DragonColors.textPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: DragonColors.midnightBlue,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: DragonColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: DragonColors.textSecondary,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        // Display — Cinzel for fantasy headings
        displayLarge: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: 0.3,
          color: DragonColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.2,
          color: DragonColors.textPrimary,
        ),

        // Headline — mixed
        headlineLarge: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: DragonColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: DragonColors.textPrimary,
        ),

        // Title — Nunito
        titleLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.4,
          color: DragonColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),

        // Body — Nunito
        bodyLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: DragonColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: DragonColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.2,
          color: DragonColors.textSecondary,
        ),

        // Label — Nunito
        labelLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textSecondary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: DragonColors.nightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button (Primary / Gold)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DragonColors.dragonGold,
          foregroundColor: DragonColors.deepVoid,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button (Secondary / Purple outline)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DragonColors.textPrimary,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: DragonColors.amethyst, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: DragonColors.nightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: DragonColors.divider, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: DragonColors.textPrimary,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DragonColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return DragonColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DragonColors.dragonGold;
          }
          return DragonColors.disabled;
        }),
      ),
    );
  }
}
