import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: AppColors.adaptive(
        isDark: isDark,
        lightColor: AppColors.surfaceLight,
        darkColor: AppColors.surfaceDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: AppColors.adaptive(
            isDark: isDark,
            lightColor: AppColors.bentoBorderLight,
            darkColor: AppColors.bentoBorderDark,
          ),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
