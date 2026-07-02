import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/constants/app_colors.dart';
import './widgets/receipt_row.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late String _orderNumber;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _animController.forward();
    
    
    final rand = Random();
    _orderNumber = 'SE-${rand.nextInt(89999) + 10000}-${rand.nextInt(89)+10}';
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.secondary,
                      size: 68,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              
              AppText(
                'Order Placed Successfully!',
                variant: AppTextVariant.displayMedium,
                fontSize: 26,
                bold: true,
                letterSpacing: -0.5,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppText(
                'Thank you for shopping with ShopEase. Your payment has been verified, and we are preparing your shipment.',
                variant: AppTextVariant.bodyMedium,
                height: 1.5,
                align: TextAlign.center,
              ),
              const SizedBox(height: 36),

              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.adaptive(
                    isDark: isDark,
                    lightColor: AppColors.backgroundLight,
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
                  children: [
                    ReceiptRow(label: 'Order Code', value: _orderNumber, isBold: true),
                    const SizedBox(height: 12),
                    const ReceiptRow(label: 'Payment Method', value: 'Google Pay Wallet'),
                    const SizedBox(height: 12),
                    const ReceiptRow(label: 'Delivery Method', value: 'Standard Shipping'),
                    const SizedBox(height: 12),
                    const ReceiptRow(label: 'Estimated Arrival', value: 'Jul 06, 2026 (In 5 days)', isAccent: true),
                  ],
                ),
              ),

              const Spacer(),

              
              CustomButton(
                text: 'Back to Home',
                icon: Icons.home_outlined,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Continue Shopping',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}