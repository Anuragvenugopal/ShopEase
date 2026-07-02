import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  
  static const Color primaryLight = Color(0xFF5F5DEC); 
  static const Color secondaryLight = Color(0xFF10B981); 
  static const Color tertiaryLight = Color(0xFFF43F5E); 
  static const Color backgroundLight = Color(0xFFF8FAFC); 
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A); 
  static const Color textSecondaryLight = Color(0xFF64748B); 
  static const Color outlineLight = Color(0xFFE2E8F0); 

  static const Color primaryDark = Color(0xFF818CF8); 
  static const Color secondaryDark = Color(0xFF34D399); 
  static const Color tertiaryDark = Color(0xFFFB7185); 
  static const Color backgroundDark = Color(0xFF090D16); 
  static const Color surfaceDark = Color(0xFF161F30); 
  static const Color textPrimaryDark = Color(0xFFF1F5F9); 
  static const Color textSecondaryDark = Color(0xFF94A3B8); 
  static const Color outlineDark = Color(0xFF2E3E50); 

  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusExtraLarge = 32.0;

  
  static List<BoxShadow> get premiumShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  
  static BoxDecoration glassCardDecoration({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? surfaceDark.withOpacity(0.7)
          : surfaceLight.withOpacity(0.85),
      borderRadius: BorderRadius.circular(radiusLarge),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05),
        width: 1.0,
      ),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ]
          : premiumShadow,
    );
  }

}