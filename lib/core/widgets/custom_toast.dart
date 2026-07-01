import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import './app_text.dart';

class CustomToast {
  CustomToast._();

  static void show(BuildContext context, String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          message,
          variant: AppTextVariant.bodyMedium,
          bold: true,
          align: TextAlign.center,
          color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
        ),
        backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.only(left: 64, right: 64, bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: isDark ? AppTheme.outlineDark : AppTheme.outlineLight,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
