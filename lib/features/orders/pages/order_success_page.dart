import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> with SingleTickerProviderStateMixin {
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
    
    // Generate a random order number for the receipt
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
              
              // Animated Success Check Circle
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

              // Title and congrats text
              Text(
                'Order Placed Successfully!',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for shopping with ShopEase. Your payment has been verified, and we are preparing your shipment.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Mock Receipt Card Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: Column(
                  children: [
                    _buildReceiptRow('Order Code', _orderNumber, theme, isBold: true),
                    const SizedBox(height: 12),
                    _buildReceiptRow('Payment Method', 'Google Pay Wallet', theme),
                    const SizedBox(height: 12),
                    _buildReceiptRow('Delivery Method', 'Standard Shipping', theme),
                    const SizedBox(height: 12),
                    _buildReceiptRow('Estimated Arrival', 'Jul 06, 2026 (In 5 days)', theme, isAccent: true),
                  ],
                ),
              ),

              const Spacer(),

              // Navigation CTAs
              CustomButton(
                text: 'Track Order Status',
                icon: Icons.local_shipping_outlined,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.orderHistory);
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

  Widget _buildReceiptRow(String label, String value, ThemeData theme, {bool isBold = false, bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold || isAccent ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
            color: isAccent ? theme.colorScheme.secondary : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
