import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/custom_toast.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/cart/cart_event.dart';
import '../../presentation/blocs/cart/cart_state.dart';
import './widgets/total_row.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  double _couponDiscountPercentage = 0.0;
  String _appliedCoupon = '';

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(double subtotal) {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'WELCOME10') {
      setState(() {
        _couponDiscountPercentage = 0.10;
        _appliedCoupon = 'WELCOME10 (10% OFF)';
      });
      CustomToast.show(
        context,
        'Coupon WELCOME10 applied! 10% discount subtracted.',
      );
    } else {
      CustomToast.show(context, 'Invalid Coupon. Try code: WELCOME10');
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponDiscountPercentage = 0.0;
      _appliedCoupon = '';
      _couponController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CartError) {
              return Center(child: Text(state.message));
            }
            if (state is CartLoaded) {
              final items = state.items;
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Your Cart is Empty',
                  description:
                      'Looks like you haven\'t added any items to your shopping cart yet. Start exploring our collections!',
                  actionText: 'Shop Products',
                  onActionPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                );
              }

              final subtotal = state.subtotal;
              final shipping = state.shipping;
              final discount = subtotal * _couponDiscountPercentage;
              final total = subtotal + shipping - discount;

              return Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final product = items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.adaptive(
                              isDark: isDark,
                              lightColor: AppColors.surfaceLight,
                              darkColor: AppColors.surfaceDark,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.adaptive(
                                isDark: isDark,
                                lightColor: AppColors.bentoBorderLight,
                                darkColor: AppColors.bentoBorderDark,
                              ),
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
                                    AppText(
                                      product.title,
                                      variant: AppTextVariant.titleMedium,
                                      fontSize: 14,
                                      bold: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    AppText(
                                      '₹${product.price.toStringAsFixed(0)}',
                                      variant: AppTextVariant.titleMedium,
                                      fontSize: 15,
                                      bold: true,
                                      color: theme.colorScheme.primary,
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
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: theme.colorScheme.tertiary,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      if (userId.isNotEmpty) {
                                        context.read<CartBloc>().add(
                                              RemoveFromCart(
                                                  userId, product.productId),
                                            );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  QuantitySelector(
                                    quantity: product.quantity,
                                    padding: 4,
                                    iconSize: 16,
                                    onChanged: (val) {
                                      if (userId.isNotEmpty) {
                                        context.read<CartBloc>().add(
                                              UpdateCartQuantity(userId,
                                                  product.productId, val),
                                            );
                                      }
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
                      color: AppColors.adaptive(
                        isDark: isDark,
                        lightColor: AppColors.surfaceLight,
                        darkColor: AppColors.surfaceDark,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.adaptive(
                            isDark: isDark,
                            lightColor: AppColors.overlayLight,
                            darkColor: AppColors.overlayDark,
                          ),
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
                                    style: const TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      labelText: 'Promo Coupon',
                                      labelStyle: const TextStyle(fontSize: 11),
                                      hintText: 'Try: WELCOME10',
                                      hintStyle: const TextStyle(fontSize: 11),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CustomButton(
                                text: 'Apply',
                                onPressed: () => _applyCoupon(subtotal),
                                width: 80,
                                height: 48,
                                fontSize: 12.0,
                              ),
                            ],
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                AppText(
                                  'Coupon applied: $_appliedCoupon',
                                  variant: AppTextVariant.bodyMedium,
                                  fontSize: 12,
                                  bold: true,
                                  color: theme.colorScheme.secondary,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                  ),
                                  onPressed: _removeCoupon,
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Subtotal
                        TotalRow(
                          label: 'Subtotal',
                          value: '₹${subtotal.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 8),

                        // Shipping
                        TotalRow(
                          label: 'Shipping',
                          value: shipping == 0
                              ? 'FREE'
                              : '₹${shipping.toStringAsFixed(0)}',
                          isAccent: shipping == 0,
                        ),
                        if (_appliedCoupon.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TotalRow(
                            label: 'Discount',
                            value: '-₹${discount.toStringAsFixed(0)}',
                            isAccent: true,
                          ),
                        ],
                        const Divider(height: 24),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppText(
                              'Total Amount',
                              variant: AppTextVariant.titleMedium,
                              bold: true,
                              fontSize: 16,
                            ),
                            AppText(
                              '₹${total.toStringAsFixed(0)}',
                              variant: AppTextVariant.titleLarge,
                              bold: true,
                              color: theme.colorScheme.primary,
                              fontSize: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Checkout CTA button
                        CustomButton(
                          text: 'Proceed to Checkout',
                          onPressed: () {
                            final route = ModalRoute.of(context);
                            if (route != null &&
                                route.isCurrent &&
                                route.settings.name == null) {
                              Navigator.pop(context); // Close bottom sheet
                            }
                            Navigator.pushNamed(context, AppRoutes.checkout);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
