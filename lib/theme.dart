import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFFF6B35);
  static const primaryLight = Color(0xFFFFE8DE);
  static const primaryDark = Color(0xFFCC5000);
  static const background = Color(0xFFF5F5F7);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF8E8E93);
  static const divider = Color(0xFFE5E5EA);
  static const tagBlue = Color(0xFFE6F1FB);
  static const tagBlueTxt = Color(0xFF185FA5);
  static const tagGreen = Color(0xFFEAF3DE);
  static const tagGreenTxt = Color(0xFF3B6D11);
  static const tagPurpleBg = Color(0xFFEEEDFE);
  static const tagPurpleTxt = Color(0xFF534AB7);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.outfitTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: GoogleFonts.outfit(
                fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
}
