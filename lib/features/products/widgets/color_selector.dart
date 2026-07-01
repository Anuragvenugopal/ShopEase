import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ColorSelector({
    super.key,
    required this.colors,
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
          'Select Color',
          variant: AppTextVariant.titleMedium,
          bold: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(colors.length, (index) {
            final col = colors[index];
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: col,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: isDark ? Colors.white : theme.colorScheme.primary,
                          width: 2.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        color: col == Colors.white ? Colors.black : Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
