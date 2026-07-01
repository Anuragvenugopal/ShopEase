import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String text;

  const ReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                name,
                variant: AppTextVariant.bodyLarge,
                bold: true,
                fontSize: 14,
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppText(
            text,
            variant: AppTextVariant.bodyMedium,
            fontSize: 13,
            height: 1.4,
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}