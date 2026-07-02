import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../../presentation/blocs/product/product_bloc.dart';
import '../../../presentation/blocs/product/product_event.dart';
import '../../../presentation/blocs/product/product_state.dart';
import '../../../presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../../presentation/blocs/wishlist/wishlist_event.dart';
import '../../../presentation/blocs/wishlist/wishlist_state.dart';
import '../../../presentation/blocs/cart/cart_bloc.dart';
import '../../../presentation/blocs/cart/cart_event.dart';
import '../../../presentation/blocs/cart/cart_state.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'Popular'; 

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoadingMore = false;

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductsLoaded && !state.hasReachedMax && !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ProductBloc>().add(LoadMoreProductsByCategory(widget.categoryName));
      }
    }
  }

  void _changeSort(String sorting) {
    setState(() {
      _sortBy = sorting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    final productState = context.watch<ProductBloc>().state;
    if (productState is ProductsLoaded) {
      _isLoadingMore = false;
    }
    final wishlistState = context.watch<WishlistBloc>().state;

    final List<ProductEntity> allProducts = productState is ProductsLoaded
        ? productState.products
        : [];
    final Set<String> wishlistedIds = wishlistState is WishlistLoaded
        ? wishlistState.wishlistedIds
        : <String>{};

    final filteredProducts = allProducts
        .where(
          (p) =>
              p.category.toLowerCase() == widget.categoryName.toLowerCase() &&
              p.isActive,
        )
        .toList();

    
    if (_sortBy == 'LowToHigh') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'HighToLow') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else {
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    final hasReachedMax = productState is ProductsLoaded ? productState.hasReachedMax : true;

    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName, showBackButton: true),
      body: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.04),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${filteredProducts.length} Products Found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: const [
                    DropdownMenuItem(
                      value: 'Popular',
                      child: Text('Popularity'),
                    ),
                    DropdownMenuItem(
                      value: 'LowToHigh',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'HighToLow',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) _changeSort(val);
                  },
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          
          Expanded(
            child: productState is ProductLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No Products Found',
                        description:
                            'We couldn\'t find any products in this category at the moment. Check back later!',
                      )
                    : BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          final cartQuantityMap = <String, int>{};
                          if (cartState is CartLoaded) {
                            for (final item in cartState.items) {
                              cartQuantityMap[item.productId] = item.quantity;
                            }
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
                            },
                            child: ListView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filteredProducts.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    final isWishlisted = wishlistedIds.contains(
                                      product.id,
                                    );
                                    final cartQty = cartQuantityMap[product.id] ?? 0;

                                    return ProductCard(
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
                                              userId,
                                              product.id,
                                              wasWishlisted,
                                            ),
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
                                            context,
                                            '${product.title} added to Cart!',
                                          );
                                        }
                                      },
                                      onRemoveFromCart: () {
                                        if (userId.isNotEmpty) {
                                          context.read<CartBloc>().add(
                                            RemoveFromCart(userId, product.id),
                                          );
                                          CustomToast.show(
                                            context,
                                            '${product.title} removed from Cart',
                                          );
                                        }
                                      },
                                      onUpdateQuantity: (newQty) {
                                        if (userId.isNotEmpty) {
                                          context.read<CartBloc>().add(
                                            UpdateCartQuantity(
                                              userId,
                                              product.id,
                                              newQty,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                if (!hasReachedMax)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
