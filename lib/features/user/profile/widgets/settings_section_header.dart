import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String label;

  const SettingsSectionHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: AppText(
        label,
        variant: AppTextVariant.titleMedium,
        bold: true,
        fontSize: 15,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
