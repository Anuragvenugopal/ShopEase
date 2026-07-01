import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

class RewardMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const RewardMetric({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            AppText(
              value,
              variant: AppTextVariant.titleLarge,
              bold: true,
              fontSize: 18,
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          label,
          variant: AppTextVariant.bodyMedium,
          fontSize: 11,
        ),
      ],
    );
  }
}