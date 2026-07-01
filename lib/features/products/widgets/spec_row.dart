import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

class SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const SpecRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(label, variant: AppTextVariant.bodyMedium),
          AppText(
            value,
            variant: AppTextVariant.bodyMedium,
            bold: true,
          ),
        ],
      ),
    );
  }
}