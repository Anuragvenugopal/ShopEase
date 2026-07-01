import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isAccent;

  const ReceiptRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          variant: AppTextVariant.bodyMedium,
          fontSize: 13,
        ),
        AppText(
          value,
          variant: AppTextVariant.bodyMedium,
          fontWeight: isBold || isAccent ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
          color: isAccent ? theme.colorScheme.secondary : theme.textTheme.bodyMedium?.color,
        ),
      ],
    );
  }
}
