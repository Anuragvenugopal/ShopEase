import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/loading_skeleton.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final double size;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular image with accent ring
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.adaptive(
                isDark: isDark,
                lightColor: AppColors.categoryCircleLight,
                darkColor: AppColors.categoryCircleDark,
              ),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.overlayLight,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => LoadingSkeleton(
                  width: size,
                  height: size,
                  borderRadius: BorderRadius.circular(size),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.category_outlined,
                    size: size * 0.4,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Category label
          AppText(
            title,
            variant: AppTextVariant.bodyMedium,
            bold: true,
            fontSize: 12,
            color: theme.colorScheme.onSurface,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}