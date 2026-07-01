import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/custom_toast.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../../presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../presentation/blocs/wishlist/wishlist_event.dart';
import '../../presentation/blocs/wishlist/wishlist_state.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/cart/cart_event.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WishlistError) {
              return Center(child: Text(state.message));
            }
            if (state is WishlistLoaded) {
              final wishlistItems = state.items;
              if (wishlistItems.isEmpty) {
                return EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'Wishlist is Empty',
                  description:
                      'Explore our catalog and tap the heart icon to save products you love for later.',
                  actionText: 'Discover Trends',
                  onActionPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: wishlistItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = wishlistItems[index];
                  return ProductCard(
                    id: product.id,
                    title: product.title,
                    imageUrl: product.imageUrl,
                    price: product.price,
                    originalPrice: product.originalPrice,
                    rating: product.rating,
                    reviewsCount: product.reviewsCount,
                    initialIsWishlisted: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: product.id,
                      );
                    },
                    onWishlistToggle: (wishlisted) {
                      if (userId.isNotEmpty) {
                        context.read<WishlistBloc>().add(
                              ToggleWishlist(userId, product.id, !wishlisted),
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
                        CustomToast.show(
                            context, '${product.title} added to Cart!');
                      }
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}