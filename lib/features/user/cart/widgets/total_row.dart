import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text.dart';

class TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAccent;

  const TotalRow({
    super.key,
    required this.label,
    required this.value,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, variant: AppTextVariant.bodyMedium),
        AppText(
          value,
          variant: AppTextVariant.bodyMedium,
          bold: true,
          color: isAccent ? theme.colorScheme.secondary : theme.textTheme.bodyMedium?.color,
        ),
      ],
    );
  }
}