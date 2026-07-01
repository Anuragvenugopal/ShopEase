import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/quantity_selector.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late DummyProduct _product;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 1;
  int _quantity = 1;
  bool _isWishlisted = false;

  final List<Color> _colors = [
    const Color(0xFF1E293B), // Navy/Slate
    const Color(0xFFF43F5E), // Rose
    const Color(0xFF10B981), // Emerald
    const Color(0xFFD97706), // Amber
  ];

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _product = DummyData.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => DummyData.products.first,
    );
    _isWishlisted = DummyData.isWishlisted(_product.id);
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    DummyData.toggleWishlist(_product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWishlisted ? 'Added to Wishlist!' : 'Removed from Wishlist'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToCart() {
    // Add product to cart with chosen quantity
    for (int i = 0; i < _quantity; i++) {
      DummyData.addToCart(_product);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity item(s) to Cart!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final discountPercent = _product.originalPrice != null
        ? (((_product.originalPrice! - _product.price) / _product.originalPrice!) * 100).round()
        : 0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        actions: [
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isWishlisted ? theme.colorScheme.tertiary : theme.colorScheme.onBackground,
            ),
            onPressed: _toggleWishlist,
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
                    tag: 'product_image_${_product.id}',
                    child: CachedNetworkImage(
                      imageUrl: _product.imageUrl,
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
                        // Category Label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _product.category.toUpperCase(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title Text
                        Text(
                          _product.title,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating & Reviews row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    _product.rating.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_product.reviewsCount} customer reviews',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Price & discount labels
                        Row(
                          children: [
                            Text(
                              '\$${_product.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (_product.originalPrice != null) ...[
                              const SizedBox(width: 12),
                              Text(
                                '\$${_product.originalPrice!.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$discountPercent% OFF',
                                  style: TextStyle(
                                    color: theme.colorScheme.tertiary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _product.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Color Selection Circles
                        Text(
                          'Select Color',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(_colors.length, (index) {
                            final col = _colors[index];
                            final isSelected = index == _selectedColorIndex;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColorIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 14),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: col,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: isDark ? Colors.white : theme.colorScheme.primary,
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: col == Colors.white ? Colors.black : Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Size Selection Blocks
                        Text(
                          'Select Size',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(_sizes.length, (index) {
                            final sz = _sizes[index];
                            final isSelected = index == _selectedSizeIndex;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSizeIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 50,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  sz,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? (isDark ? Colors.black : Colors.white)
                                        : theme.colorScheme.onBackground,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 28),

                        // Collapsible Product Specs Sheet
                        ExpansionTile(
                          title: Text(
                            'Specifications',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            _buildSpecRow('SKU Code', _product.sku, context),
                            _buildSpecRow('Barcode GTIN', _product.barcode, context),
                            _buildSpecRow('Stock Availability', '${_product.stock} units remaining', context),
                            _buildSpecRow('Country of Origin', 'United States', context),
                          ],
                        ),

                        // Collapsible Reviews Section
                        ExpansionTile(
                          title: Text(
                            'Reviews (${_product.reviewsCount})',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.symmetric(vertical: 12),
                          children: [
                            _buildReviewItem('Sarah Jenkins', 5, 'Absolutely love the build quality! Clear sound and long-lasting battery life. Highly recommended!', context),
                            _buildReviewItem('Michael Miller', 4, 'Very comfortable. Noise cancellation works well on office commutes. Pricey but worth it.', context),
                          ],
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
              color: isDark ? const Color(0xFF161F30) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity selector
                  QuantitySelector(
                    quantity: _quantity,
                    onChanged: (val) {
                      setState(() {
                        _quantity = val;
                      });
                    },
                  ),
                  const SizedBox(width: 16),

                  // Add to Cart button
                  Expanded(
                    child: CustomButton(
                      text: 'Add to Cart',
                      onPressed: _addToCart,
                      icon: Icons.shopping_cart_outlined,
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

  Widget _buildSpecRow(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, double rating, String text, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.4)),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
