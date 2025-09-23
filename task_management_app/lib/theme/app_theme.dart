import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();
  static const background = Color(0xFFF8F7FF); // exact background match
  static const white = Colors.white;
  static const textPrimary = Color(0xFF1D1D1D);
  static const textSecondary = Color(0xFF8E8E93);
  static const textLight = Color(0xFFBEBEBE);
  static const tagImportant = Color(0xFFFF6B85);
  static const tagUrgent = Color(0xFFFFB347);
  static const tagBasic = Color(0xFF34C759);
  // Purple gradient (exact match from design)
  static const purpleStart = Color(0xFF8B5FBF);
  static const purpleEnd = Color(0xFFB794F6);
  // Blue gradient (exact match from design)  
  static const blueStart = Color(0xFF4A90E2);
  static const blueEnd = Color(0xFF7BB3F0);
  // Progress colors
  static const progressBg = Color(0xFFF0F0F0);
  static const progressFill = Color(0xFF8B5FBF);
}

class AppTextStyles {
  AppTextStyles._();
  static TextStyle get h1 => GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary); // reduced from 28
  static TextStyle get h2 => GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get h3 => GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get body => GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.4);
  static TextStyle get bodyLight => GoogleFonts.poppins(fontSize: 14, color: AppColors.textLight, height: 1.4);
  static TextStyle get small => GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary);
  static TextStyle get tiny => GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary);
  static TextStyle get button => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white);
  // Specific styles for greeting
  static TextStyle get greeting => GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get subGreeting => GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final scheme = base.colorScheme.copyWith(
    brightness: Brightness.light,
    primary: AppColors.purpleStart,
    onPrimary: Colors.white,
    secondary: AppColors.blueStart,
    onSecondary: Colors.white,
    surface: AppColors.white,
    onSurface: AppColors.textPrimary,
    background: AppColors.background,
    onBackground: AppColors.textPrimary,
    error: const Color(0xFFFF4D4D),
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    cardColor: AppColors.white,
    canvasColor: AppColors.background,
    dialogBackgroundColor: AppColors.white,
    splashColor: AppColors.purpleStart.withValues(alpha: .08),
    highlightColor: AppColors.purpleStart.withValues(alpha: .05),
  );
}
