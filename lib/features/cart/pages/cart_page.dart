import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/quantity_selector.dart';
import '../../../core/widgets/empty_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _couponController = TextEditingController();
  double _couponDiscount = 0.0;
  String _appliedCoupon = '';

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'WELCOME10') {
      setState(() {
        _couponDiscount = DummyData.getCartTotal() * 0.10;
        _appliedCoupon = 'WELCOME10 (10% OFF)';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon WELCOME10 applied! 10% discount subtracted.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Coupon. Try code: WELCOME10'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponDiscount = 0.0;
      _appliedCoupon = '';
      _couponController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtotal = DummyData.getCartTotal();
    final shipping = subtotal > 150 ? 0.0 : (subtotal == 0 ? 0.0 : 15.00);
    // recalculate discount if cart value changed
    final discount = _appliedCoupon.isNotEmpty ? subtotal * 0.10 : 0.0;
    final total = subtotal + shipping - discount;

    return Scaffold(
      body: SafeArea(
        child: DummyData.cart.isEmpty
            ? EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'Your Cart is Empty',
                description: 'Looks like you haven\'t added any items to your shopping cart yet. Start exploring our collections!',
                actionText: 'Shop Products',
                onActionPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              )
            : Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: DummyData.cart.length,
                      itemBuilder: (context, index) {
                        final product = DummyData.cart[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161F30) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Quantity and Delete controls
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.tertiary, size: 22),
                                    onPressed: () {
                                      setState(() {
                                        DummyData.removeFromCart(product);
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  QuantitySelector(
                                    quantity: product.quantity,
                                    padding: 4,
                                    iconSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        product.quantity = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Cart Totals and Promo Panel
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Coupon promo code row
                        if (_appliedCoupon.isEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextField(
                                    controller: _couponController,
                                    decoration: InputDecoration(
                                      labelText: 'Promo Coupon',
                                      hintText: 'Try: WELCOME10',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CustomButton(
                                text: 'Apply',
                                onPressed: _applyCoupon,
                                width: 90,
                                height: 48,
                              ),
                            ],
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline_rounded, color: theme.colorScheme.secondary, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  'Coupon applied: $_appliedCoupon',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 20),
                                  onPressed: _removeCoupon,
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Subtotal
                        _buildTotalRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', theme),
                        const SizedBox(height: 8),
                        
                        // Shipping
                        _buildTotalRow(
                          'Shipping',
                          shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}',
                          theme,
                          isAccent: shipping == 0,
                        ),
                        if (_appliedCoupon.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildTotalRow('Discount', '-\$${discount.toStringAsFixed(2)}', theme, isAccent: true),
                        ],
                        const Divider(height: 24),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Checkout CTA button
                        CustomButton(
                          text: 'Proceed to Checkout',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.checkout);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, ThemeData theme, {bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isAccent ? theme.colorScheme.secondary : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
