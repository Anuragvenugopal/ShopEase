import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_toast.dart';
import './status_progress.dart';

class OrderHistoryCard extends StatelessWidget {
  final String orderId;
  final String date;
  final double price;
  final String status;
  final int statusStep;
  final String productTitle;
  final String productImageUrl;
  final bool canCancel;
  final VoidCallback? onBuyAgain;

  const OrderHistoryCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.price,
    required this.status,
    required this.statusStep,
    required this.productTitle,
    required this.productImageUrl,
    required this.canCancel,
    this.onBuyAgain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.adaptive(
          isDark: isDark,
          lightColor: AppColors.surfaceLight,
          darkColor: AppColors.surfaceDark,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.adaptive(
            isDark: isDark,
            lightColor: AppColors.bentoBorderLight,
            darkColor: AppColors.bentoBorderDark,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    orderId,
                    variant: AppTextVariant.titleMedium,
                    bold: true,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'Placed on $date',
                    variant: AppTextVariant.bodyMedium,
                    fontSize: 12,
                  ),
                ],
              ),
              AppText(
                '₹${price.toStringAsFixed(0)}',
                variant: AppTextVariant.titleMedium,
                bold: true,
                color: theme.colorScheme.primary,
                fontSize: 16,
              ),
            ],
          ),
          const Divider(height: 24),

          // Order Item thumbnail + title
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: productImageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    color: AppColors.adaptive(
                      isDark: isDark,
                      lightColor: AppColors.overlayLight,
                      darkColor: AppColors.overlayDark,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    color: AppColors.adaptive(
                      isDark: isDark,
                      lightColor: AppColors.overlayLight,
                      darkColor: AppColors.overlayDark,
                    ),
                    child: const Icon(Icons.broken_image_outlined, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(
                  productTitle,
                  variant: AppTextVariant.bodyMedium,
                  bold: true,
                  fontSize: 13,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal Status Tracker Stepper
          AppText(
            'Tracking Status: $status',
            variant: AppTextVariant.bodyMedium,
            bold: true,
            fontSize: 13,
          ),
          const SizedBox(height: 12),
          StatusProgress(currentStep: statusStep),
          const SizedBox(height: 20),

          // Cancel or Write Review action buttons
          Row(
            children: [
              if (canCancel)
                Expanded(
                  child: CustomButton(
                    text: 'Cancel Order',
                    isOutlined: true,
                    height: 44,
                    onPressed: () {
                      ConfirmationDialog.show(
                        context,
                        title: 'Cancel Order',
                        content: 'Are you sure you want to cancel this order? This action cannot be undone.',
                        confirmText: 'Yes, Cancel',
                        isDangerous: true,
                        onConfirm: () {
                          CustomToast.show(context, 'Order cancellation request sent successfully.');
                        },
                      );
                    },
                  ),
                )
              else ...[
                Expanded(
                  child: CustomButton(
                    text: 'Buy Again',
                    height: 44,
                    onPressed: onBuyAgain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Write Review',
                    isOutlined: true,
                    height: 44,
                    onPressed: () {
                      CustomToast.show(context, 'Review platform mock dialog opened.');
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}