import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../domain/entities/cart_item_entity.dart';
import '../../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../../presentation/blocs/auth/auth_state.dart';
import '../../../../presentation/blocs/product/product_bloc.dart';
import '../../../../presentation/blocs/product/product_state.dart';
import '../../../../presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../../../presentation/blocs/wishlist/wishlist_event.dart';
import '../../../../presentation/blocs/wishlist/wishlist_state.dart';
import '../../../../presentation/blocs/cart/cart_bloc.dart';
import '../../../../presentation/blocs/cart/cart_event.dart';
import '../../../../presentation/blocs/cart/cart_state.dart';

class TrendingProductsGrid extends StatelessWidget {
  const TrendingProductsGrid({
    super.key,
    required this.onNavigateToCart,
  });

  final VoidCallback onNavigateToCart;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        
        if (productState is ProductLoading) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Shimmer.fromColors(
            baseColor: isDark ? const Color(0xFF1E293B) : Colors.grey[300]!,
            highlightColor: isDark ? const Color(0xFF334155) : Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(
                      4,
                      (index) => SizedBox(
                        width: cardWidth,
                        height: 240,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        
        if (productState is ProductError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(productState.message),
            ),
          );
        }

        
        if (productState is ProductsLoaded) {
          final products = productState.products.where((p) => p.isActive).toList();
          if (products.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No products available'),
              ),
            );
          }

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final cartQuantityMap = <String, int>{};
              if (cartState is CartLoaded) {
                for (final item in cartState.items) {
                  cartQuantityMap[item.productId] = item.quantity;
                }
              }

              return BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, wishlistState) {
                  final wishlistedIds = wishlistState is WishlistLoaded
                      ? wishlistState.wishlistedIds
                      : <String>{};

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = (constraints.maxWidth - 12) / 2;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(products.length, (index) {
                            final product = products[index];
                            final isWishlisted =
                                wishlistedIds.contains(product.id);
                            final cartQty =
                                cartQuantityMap[product.id] ?? 0;

                            return SizedBox(
                              width: cardWidth,
                              child: ProductCard(
                                id: product.id,
                                title: product.title,
                                imageUrl: product.imageUrl,
                                price: product.price,
                                originalPrice: product.originalPrice,
                                offerPercentage: product.offerPercentage,
                                rating: product.rating,
                                reviewsCount: product.reviewsCount,
                                initialIsWishlisted: isWishlisted,
                                cartQuantity: cartQty,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.productDetails,
                                    arguments: product.id,
                                  );
                                },
                                onWishlistToggle: (wasWishlisted) {
                                  if (userId.isNotEmpty) {
                                    context.read<WishlistBloc>().add(
                                          ToggleWishlist(
                                              userId, product.id, wasWishlisted),
                                        );
                                  }
                                },
                                onAddToCart: () {
                                  if (userId.isNotEmpty) {
                                    context.read<CartBloc>().add(
                                          AddToCart(
                                            userId,
                                            CartItemEntity(
                                              productId: product.id,
                                              title: product.title,
                                              imageUrl: product.imageUrl,
                                              price: product.price,
                                              quantity: 1,
                                            ),
                                          ),
                                        );
                                    CustomToast.show(context,
                                        '${product.title} added to Cart!');
                                  }
                                },
                                onRemoveFromCart: () {
                                  if (userId.isNotEmpty) {
                                    context.read<CartBloc>().add(
                                          RemoveFromCart(userId, product.id),
                                        );
                                    CustomToast.show(context,
                                        '${product.title} removed from Cart');
                                  }
                                },
                                onUpdateQuantity: (newQty) {
                                  if (userId.isNotEmpty) {
                                    context.read<CartBloc>().add(
                                          UpdateCartQuantity(
                                              userId, product.id, newQty),
                                        );
                                  }
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
