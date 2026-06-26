import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const jungleGreen = Color(0xFF1B4D2E);
  static const canopyGreen = Color(0xFF2D6A4F);
  static const mossGreen = Color(0xFF52B788);
  static const safeZoneGold = Color(0xFFFFD700);
  static const backgroundDark = Color(0xFF0D2B1A);
  static const textLight = Color(0xFFE8F5E9);
  static const textMuted = Color(0xFFA5D6A7);
  
  static const playerOneColor = Color(0xFFFFCA28); // Yellow
  static const playerTwoColor = Color(0xFF007BFF); // More blue
}

class AppTextStyles {
  static TextStyle get headline1 => GoogleFonts.cinzelDecorative(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.safeZoneGold,
        shadows: [
          const Shadow(color: AppColors.jungleGreen, offset: Offset(2, 2), blurRadius: 4),
        ],
      );

  static TextStyle get headline2 => GoogleFonts.cinzelDecorative(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      );

  static TextStyle get body => GoogleFonts.outfit(
        fontSize: 16,
        color: AppColors.textLight,
      );

  static TextStyle get bodyMuted => GoogleFonts.outfit(
        fontSize: 14,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      );
}
