import 'package:flutter/material.dart';








abstract final class AppColors {
  AppColors._();

  
  static const Color primaryLight   = Color(0xFF5F5DEC); 
  static const Color secondaryLight = Color(0xFF10B981); 
  static const Color tertiaryLight  = Color(0xFFF43F5E); 

  static const Color primaryDark    = Color(0xFF818CF8); 
  static const Color secondaryDark  = Color(0xFF34D399); 
  static const Color tertiaryDark   = Color(0xFFFB7185); 

  
  static const Color backgroundLight = Color(0xFFF8FAFC); 
  static const Color backgroundDark  = Color(0xFF090D16); 

  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color surfaceDark     = Color(0xFF161F30); 

  
  static const Color textPrimaryLight   = Color(0xFF0F172A); 
  static const Color textSecondaryLight = Color(0xFF64748B); 

  static const Color textPrimaryDark    = Color(0xFFF1F5F9); 
  static const Color textSecondaryDark  = Color(0xFF94A3B8); 

  
  static const Color outlineLight = Color(0xFFE2E8F0); 
  static const Color outlineDark  = Color(0xFF2E3E50); 

  

  
  static const Color searchBarLight = Color(0xFFF1F5F9);

  
  static const Color searchBarDark  = Color(0xFF1E293B);

  
  static Color overlayLight = Colors.black.withOpacity(0.04);

  
  static Color overlayDark  = Colors.white.withOpacity(0.05);

  
  static Color bannerGradientStart = Colors.black.withOpacity(0.6);

  
  static const Color bannerLabelColor = Colors.white;

  

  
  static const Color categoryCircleDark  = Color(0xFF1E293B);

  
  static const Color categoryCircleLight = Colors.white;

  

  
  static const Color promoFlashStart = Color(0xFF5F5DEC);

  
  static const Color promoFlashEnd   = Color(0xFF818CF8);

  
  static const Color promoFlashBtn   = Color(0xFF5F5DEC);

  
  static const Color promoTechLight  = Color(0xFFE2E8F0);

  
  static const Color promoTechDark   = Color(0xFF161F30);

  
  static const Color promoFashionBgLight     = Color(0xFFFEE2E2);

  
  static const Color promoFashionBorderLight = Color(0xFFFECACA);

  
  static const Color promoFashionTitleLight  = Color(0xFF991B1B);

  
  static const Color promoFashionSubLight    = Color(0xFFC24141);

  
  static const Color promoFashionTitleDark   = Color(0xFFFCA5A5);

  
  static Color bentoBorderDark  = Colors.white.withOpacity(0.12);

  
  static Color bentoBorderLight = Colors.black.withOpacity(0.08);

  
  static const Color productNavy    = Color(0xFF1E293B);
  static const Color productRose    = Color(0xFFF43F5E);
  static const Color productEmerald = Color(0xFF10B981);
  static const Color productAmber   = Color(0xFFD97706);

  
  static const Color loyaltyLightStart = Color(0xFFEEF2FF);
  static const Color loyaltyLightEnd   = Color(0xFFFAE8FF);
  static const Color loyaltyDarkStart  = Color(0xFF1E1B4B);
  static const Color loyaltyDarkEnd    = Color(0xFF311042);

  

  
  static Color adaptive({
    required bool isDark,
    required Color lightColor,
    required Color darkColor,
  }) =>
      isDark ? darkColor : lightColor;
}
