import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Select Size',
          variant: AppTextVariant.titleMedium,
          bold: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(sizes.length, (index) {
            final sz = sizes[index];
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 50,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : AppColors.adaptive(
                          isDark: isDark,
                          lightColor: AppColors.searchBarLight,
                          darkColor: AppColors.searchBarDark,
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.adaptive(
                            isDark: isDark,
                            lightColor: AppColors.bentoBorderLight,
                            darkColor: AppColors.bentoBorderDark,
                          ),
                  ),
                ),
                alignment: Alignment.center,
                child: AppText(
                  sz,
                  variant: AppTextVariant.bodyMedium,
                  bold: true,
                  color: isSelected
                      ? (isDark ? Colors.black : Colors.white)
                      : theme.colorScheme.onBackground,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
