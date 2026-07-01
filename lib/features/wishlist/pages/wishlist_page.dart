import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/empty_state.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: DummyData.wishlist.isEmpty
            ? EmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'Wishlist is Empty',
                description: 'Explore our catalog and tap the heart icon to save products you love for later.',
                actionText: 'Discover Trends',
                onActionPressed: () {
                  // Switch tab back to Shop Front tab (index 0) if integrated in home shell,
                  // or redirect using navigator
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: DummyData.wishlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = DummyData.wishlist[index];
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
                      ).then((_) {
                        // refresh list state on return in case details toggled wishlist
                        setState(() {});
                      });
                    },
                    onAddToCart: () {
                      DummyData.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to Cart!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
