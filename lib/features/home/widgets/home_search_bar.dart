import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.adaptive(
              isDark: isDark,
              lightColor: AppColors.searchBarLight,
              darkColor: AppColors.searchBarDark,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.adaptive(
                isDark: isDark,
                lightColor: AppColors.overlayLight,
                darkColor: AppColors.overlayDark,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  'Search products, brands, or categories...',
                  variant: AppTextVariant.bodyMedium,
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.tune_rounded,
                  color: theme.colorScheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
