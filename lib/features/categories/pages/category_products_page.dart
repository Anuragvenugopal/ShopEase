import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/empty_state.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late List<DummyProduct> _filteredProducts;
  String _sortBy = 'Popular'; // Popular, LowToHigh, HighToLow

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _filteredProducts = DummyData.products
        .where((p) => p.category.toLowerCase() == widget.categoryName.toLowerCase())
        .toList();
    _sortProducts();
  }

  void _sortProducts() {
    if (_sortBy == 'LowToHigh') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'HighToLow') {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else {
      // sort by rating/popularity for 'Popular'
      _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  void _changeSort(String sorting) {
    setState(() {
      _sortBy = sorting;
      _sortProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.categoryName,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filter Sub-header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_filteredProducts.length} Products Found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                
                // Sorting dropdown selector
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: const [
                    DropdownMenuItem(value: 'Popular', child: Text('Popularity')),
                    DropdownMenuItem(value: 'LowToHigh', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: 'HighToLow', child: Text('Price: High to Low')),
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
          
          // Products Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No Products Found',
                    description: 'We couldn\'t find any products in this category at the moment. Check back later!',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        id: product.id,
                        title: product.title,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        rating: product.rating,
                        reviewsCount: product.reviewsCount,
                        initialIsWishlisted: DummyData.isWishlisted(product.id),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetails,
                            arguments: product.id,
                          );
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
        ],
      ),
    );
  }
}
