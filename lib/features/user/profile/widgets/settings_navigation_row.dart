import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text.dart';

class SettingsNavigationRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsNavigationRow({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AppText(title, variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }
}
