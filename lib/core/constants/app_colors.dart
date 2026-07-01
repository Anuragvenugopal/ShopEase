import 'package:flutter/material.dart';

/// Centralised colour palette for the ShopEase app.
///
/// Usage:
/// ```dart
/// color: AppColors.searchBarDark
/// color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight
/// ```
abstract final class AppColors {
  AppColors._();

  // ─── Brand colours ─────────────────────────────────────────────────────────
  static const Color primaryLight   = Color(0xFF5F5DEC); // Royal Violet
  static const Color secondaryLight = Color(0xFF10B981); // Emerald
  static const Color tertiaryLight  = Color(0xFFF43F5E); // Rose Accent

  static const Color primaryDark    = Color(0xFF818CF8); // Indigo Light
  static const Color secondaryDark  = Color(0xFF34D399); // Light Emerald
  static const Color tertiaryDark   = Color(0xFFFB7185); // Light Rose

  // ─── Background / Surface ─────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC); // Soft Slate 50
  static const Color backgroundDark  = Color(0xFF090D16); // Obsidian Slate

  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color surfaceDark     = Color(0xFF161F30); // Sleek card blue-gray

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500

  static const Color textPrimaryDark    = Color(0xFFF1F5F9); // Slate 100
  static const Color textSecondaryDark  = Color(0xFF94A3B8); // Slate 400

  // ─── Outline / Border ──────────────────────────────────────────────────────
  static const Color outlineLight = Color(0xFFE2E8F0); // Slate 200
  static const Color outlineDark  = Color(0xFF2E3E50); // Muted outline

  // ─── Home-specific UI colours ──────────────────────────────────────────────

  /// Search bar background (light)
  static const Color searchBarLight = Color(0xFFF1F5F9);

  /// Search bar background (dark)
  static const Color searchBarDark  = Color(0xFF1E293B);

  /// Subtle overlay used on image placeholders & menu buttons (light)
  static Color overlayLight = Colors.black.withOpacity(0.04);

  /// Subtle overlay used on image placeholders & menu buttons (dark)
  static Color overlayDark  = Colors.white.withOpacity(0.05);

  /// Banner image gradient start (bottom-right scrim)
  static Color bannerGradientStart = Colors.black.withOpacity(0.6);

  /// Banner on-image label colour
  static const Color bannerLabelColor = Colors.white;

  // ─── Category card ─────────────────────────────────────────────────────────

  /// Category circle background (dark)
  static const Color categoryCircleDark  = Color(0xFF1E293B);

  /// Category circle background (light)
  static const Color categoryCircleLight = Colors.white;

  // ─── Promo bento ───────────────────────────────────────────────────────────

  /// Flash-sale card gradient start
  static const Color promoFlashStart = Color(0xFF5F5DEC);

  /// Flash-sale card gradient end
  static const Color promoFlashEnd   = Color(0xFF818CF8);

  /// Flash-sale button foreground
  static const Color promoFlashBtn   = Color(0xFF5F5DEC);

  /// Tech bento background (light)
  static const Color promoTechLight  = Color(0xFFE2E8F0);

  /// Tech bento background (dark)
  static const Color promoTechDark   = Color(0xFF161F30);

  /// Fashion bento background (light)
  static const Color promoFashionBgLight     = Color(0xFFFEE2E2);

  /// Fashion bento border (light)
  static const Color promoFashionBorderLight = Color(0xFFFECACA);

  /// Fashion bento title (light)
  static const Color promoFashionTitleLight  = Color(0xFF991B1B);

  /// Fashion bento subtitle (light)
  static const Color promoFashionSubLight    = Color(0xFFC24141);

  /// Fashion bento title (dark)
  static const Color promoFashionTitleDark   = Color(0xFFFCA5A5);

  /// Bento card border overlay (dark)
  static Color bentoBorderDark  = Colors.white.withOpacity(0.12);

  /// Bento card border overlay (light)
  static Color bentoBorderLight = Colors.black.withOpacity(0.08);

  // ─── Product Selection Colors ──────────────────────────────────────────────
  static const Color productNavy    = Color(0xFF1E293B);
  static const Color productRose    = Color(0xFFF43F5E);
  static const Color productEmerald = Color(0xFF10B981);
  static const Color productAmber   = Color(0xFFD97706);

  // ─── Profile / Loyalty Card ───────────────────────────────────────────────
  static const Color loyaltyLightStart = Color(0xFFEEF2FF);
  static const Color loyaltyLightEnd   = Color(0xFFFAE8FF);
  static const Color loyaltyDarkStart  = Color(0xFF1E1B4B);
  static const Color loyaltyDarkEnd    = Color(0xFF311042);

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Returns [darkColor] when [isDark] is true, else [lightColor].
  static Color adaptive({
    required bool isDark,
    required Color lightColor,
    required Color darkColor,
  }) =>
      isDark ? darkColor : lightColor;
}
