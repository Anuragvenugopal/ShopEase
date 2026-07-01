import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? tileColor;
  final Color? iconColor;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.tileColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: tileColor ??
          AppColors.adaptive(
            isDark: isDark,
            lightColor: AppColors.surfaceLight,
            darkColor: AppColors.surfaceDark,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.adaptive(
            isDark: isDark,
            lightColor: AppColors.bentoBorderLight,
            darkColor: AppColors.bentoBorderDark,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.7)),
        title: AppText(
          title,
          variant: AppTextVariant.bodyLarge,
          bold: true,
          fontSize: 14,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}