import 'package:flutter/material.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/widgets/app_text.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsHeader({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountPercent = product.originalPrice != null
        ? (((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppText(
            product.category.toUpperCase(),
            variant: AppTextVariant.labelLarge,
            fontSize: 11,
            bold: true,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Title Text
        AppText(
          product.title,
          variant: AppTextVariant.displayMedium,
          fontSize: 24,
          bold: true,
          letterSpacing: -0.5,
        ),
        const SizedBox(height: 12),

        // Rating & Reviews row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  AppText(
                    product.rating.toString(),
                    variant: AppTextVariant.bodyMedium,
                    bold: true,
                    fontSize: 13,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppText(
              '${product.reviewsCount} customer reviews',
              variant: AppTextVariant.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Price & discount labels
        Row(
          children: [
            AppText(
              '₹${product.price.toStringAsFixed(0)}',
              variant: AppTextVariant.titleLarge,
              fontSize: 26,
              bold: true,
              color: theme.colorScheme.primary,
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 12),
              AppText(
                '₹${product.originalPrice!.toStringAsFixed(0)}',
                variant: AppTextVariant.titleMedium,
                fontSize: 18,
                decoration: TextDecoration.lineThrough,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  '$discountPercent% OFF',
                  variant: AppTextVariant.bodyMedium,
                  color: theme.colorScheme.tertiary,
                  fontSize: 12,
                  bold: true,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
