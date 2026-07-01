import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text.dart';

class PromoBento extends StatelessWidget {
  const PromoBento({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bentoBorder = AppColors.adaptive(
      isDark: isDark,
      lightColor: AppColors.bentoBorderLight,
      darkColor: AppColors.bentoBorderDark,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // ── Left: Flash Sale card ──────────────────────────────────────
          Expanded(
            flex: 4,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.promoFlashStart, AppColors.promoFlashEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: bentoBorder, width: 1.2),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.flash_on_rounded,
                        color: AppColors.bannerLabelColor,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      const AppText(
                        'Flash Sale',
                        variant: AppTextVariant.titleLarge,
                        bold: true,
                        fontSize: 20,
                        color: AppColors.bannerLabelColor,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        '2 Hours Remaining',
                        variant: AppTextVariant.bodySmall,
                        fontSize: 12,
                        color: AppColors.bannerLabelColor.withOpacity(0.75),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.categoryProducts,
                      arguments: 'Electronics',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bannerLabelColor,
                      foregroundColor: AppColors.promoFlashBtn,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const AppText(
                      'Shop Now',
                      variant: AppTextVariant.labelMedium,
                      bold: true,
                      fontSize: 12,
                      color: AppColors.promoFlashBtn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Right: two stacked mini cards ────────────────────────────
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Premium Tech card
                Container(
                  height: 94,
                  decoration: BoxDecoration(
                    color: AppColors.adaptive(
                      isDark: isDark,
                      lightColor: AppColors.promoTechLight,
                      darkColor: AppColors.promoTechDark,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: bentoBorder, width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              'Premium Tech',
                              variant: AppTextVariant.bodyLarge,
                              bold: true,
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              'Save up to ₹100',
                              variant: AppTextVariant.bodySmall,
                              fontSize: 11,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.headphones_rounded,
                          color: theme.colorScheme.primary, size: 32),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // New Fashion card
                Container(
                  height: 94,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.promoTechDark
                        : AppColors.promoFashionBgLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.bentoBorderDark
                          : AppColors.promoFashionBorderLight,
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              'New Fashion',
                              variant: AppTextVariant.bodyLarge,
                              bold: true,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.promoFashionTitleDark
                                  : AppColors.promoFashionTitleLight,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              'Free Shipping',
                              variant: AppTextVariant.bodySmall,
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.bannerLabelColor.withOpacity(0.7)
                                  : AppColors.promoFashionSubLight,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.checkroom_rounded,
                          color: theme.colorScheme.tertiary, size: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}