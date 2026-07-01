import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/app_text.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/product/product_state.dart';
import '../../presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../presentation/blocs/wishlist/wishlist_event.dart';
import '../../presentation/blocs/wishlist/wishlist_state.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/cart/cart_event.dart';
import '../../presentation/blocs/cart/cart_state.dart';
import './widgets/spec_row.dart';
import './widgets/review_item.dart';
import './widgets/size_selector.dart';
import './widgets/product_details_header.dart';
import '../../core/widgets/custom_toast.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedSizeIndex = 1;
  int _quantity = 1;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];

  void _toggleWishlist(String userId, bool isWishlisted) {
    if (userId.isEmpty) return;
    context.read<WishlistBloc>().add(
      ToggleWishlist(userId, widget.productId, isWishlisted),
    );
    CustomToast.show(
      context,
      !isWishlisted ? 'Added to Wishlist!' : 'Removed from Wishlist',
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(
                    0.2,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const AppText(
                      'Shopping Cart',
                      variant: AppTextVariant.titleLarge,
                      bold: true,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Expanded(child: CartScreen()),
            ],
          ),
        );
      },
    );
  }

  void _addToCart(ProductEntity product, String userId) {
    if (userId.isEmpty) return;
    // Add product to cart with chosen quantity
    context.read<CartBloc>().add(
      AddToCart(
        userId,
        CartItemEntity(
          productId: product.id,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: _quantity,
        ),
      ),
    );

    _showCartBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    final productState = context.watch<ProductBloc>().state;
    final wishlistState = context.watch<WishlistBloc>().state;
    final cartState = context.watch<CartBloc>().state;

    final isWishlisted = wishlistState is WishlistLoaded
        ? wishlistState.wishlistedIds.contains(widget.productId)
        : false;

    final cartCount = cartState is CartLoaded ? cartState.totalItems : 0;

    // Get quantity of this product in the cart
    final cartItem = cartState is CartLoaded
        ? cartState.items.firstWhere(
            (item) => item.productId == widget.productId,
            orElse: () => const CartItemEntity(
              productId: '',
              title: '',
              imageUrl: '',
              price: 0,
              quantity: 0,
            ),
          )
        : null;
    final cartQty = cartItem?.quantity ?? 0;
    final isInCart = cartQty > 0;

    ProductEntity? product;
    if (productState is ProductsLoaded) {
      product = productState.products.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => productState.products.first,
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Product Details',
          showBackButton: true,
        ),
        body: Shimmer.fromColors(
          baseColor: isDark ? const Color(0xFF1E293B) : Colors.grey[300]!,
          highlightColor: isDark ? const Color(0xFF334155) : Colors.grey[100]!,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 250,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentProduct = product;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        showCartBadge: true,
        cartCount: cartCount,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isWishlisted
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.onBackground,
            ),
            onPressed: () => _toggleWishlist(userId, isWishlisted),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Banner Image Hero
                  Hero(
                    tag: 'product_image_${currentProduct.id}',
                    child: CachedNetworkImage(
                      imageUrl: currentProduct.imageUrl,
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Details Header (Category, Title, Rating, Price)
                        ProductDetailsHeader(product: currentProduct),
                        const SizedBox(height: 24),

                        // Description
                        const AppText(
                          'Description',
                          variant: AppTextVariant.titleMedium,
                          bold: true,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          currentProduct.description,
                          variant: AppTextVariant.bodyMedium,
                          height: 1.6,
                          fontSize: 14.5,
                        ),
                        const SizedBox(height: 24),

                        // Size Selection Blocks
                        SizeSelector(
                          sizes: _sizes,
                          selectedIndex: _selectedSizeIndex,
                          onSelected: (index) {
                            setState(() {
                              _selectedSizeIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 28),

                        // Collapsible Product Specs Sheet
                        ExpansionTile(
                          title: const AppText(
                            'Specifications',
                            variant: AppTextVariant.titleMedium,
                            bold: true,
                          ),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          children: [
                            SpecRow(
                              label: 'SKU Code',
                              value: currentProduct.sku,
                            ),
                            SpecRow(
                              label: 'Barcode GTIN',
                              value: currentProduct.barcode,
                            ),
                            SpecRow(
                              label: 'Stock Availability',
                              value: '${currentProduct.stock} units remaining',
                            ),
                            const SpecRow(
                              label: 'Country of Origin',
                              value: 'United States',
                            ),
                          ],
                        ),

                        // Collapsible Reviews Section
                        ExpansionTile(
                          title: AppText(
                            'Reviews (${currentProduct.reviews.length})',
                            variant: AppTextVariant.titleMedium,
                            bold: true,
                          ),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          children: currentProduct.reviews.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: AppText(
                                      'No reviews for this product yet.',
                                      variant: AppTextVariant.bodyMedium,
                                    ),
                                  ),
                                ]
                              : currentProduct.reviews
                                    .map(
                                      (r) => ReviewItem(
                                        name: r.name,
                                        rating: r.rating,
                                        text: r.text,
                                      ),
                                    )
                                    .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom sticky CTA action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.adaptive(
                isDark: isDark,
                lightColor: AppColors.surfaceLight,
                darkColor: AppColors.surfaceDark,
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
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity selector
                  QuantitySelector(
                    quantity: isInCart ? cartQty : _quantity,
                    minQuantity: isInCart ? 0 : 1,
                    onChanged: (val) {
                      if (isInCart) {
                        if (userId.isNotEmpty) {
                          if (val <= 0) {
                            context.read<CartBloc>().add(
                                  RemoveFromCart(userId, widget.productId),
                                );
                          } else {
                            context.read<CartBloc>().add(
                                  UpdateCartQuantity(userId, widget.productId, val),
                                );
                          }
                        }
                      } else {
                        setState(() {
                          _quantity = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 16),

                  // Add to Cart / View Cart button
                  Expanded(
                    child: CustomButton(
                      text: isInCart ? 'View Cart' : 'Add to Cart',
                      onPressed: () {
                        if (isInCart) {
                          _showCartBottomSheet(context);
                        } else {
                          _addToCart(currentProduct, userId);
                        }
                      },
                      icon: isInCart ? Icons.shopping_bag_outlined : Icons.shopping_cart_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
