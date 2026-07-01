import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

/// A reusable section header row with a title on the left
/// and an optional "See All" tap target on the right.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  final String title;

  /// If null the "See All" link is not rendered.
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            title,
            variant: AppTextVariant.titleMedium,
            bold: true,
            letterSpacing: -0.5,
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const AppText(
                'See All',
                variant: AppTextVariant.labelLarge,
                bold: true,
              ),
            ),
        ],
      ),
    );
  }
}
