import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<DummyProduct> _searchResults = [];
  bool _isSearching = false;
  
  // Active Filters
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(10, 500);
  double _minRating = 0.0;

  final List<String> _recentSearches = ['Headphones', 'Jacket', 'Face Serum'];
  final List<String> _popularTags = ['Electronics', 'Fashion', 'Beauty', 'Sports', 'Decor'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = DummyData.products.where((product) {
        final matchesQuery = product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        final matchesPrice = product.price >= _priceRange.start && product.price <= _priceRange.end;
        final matchesRating = product.rating >= _minRating;

        return matchesQuery && matchesCategory && matchesPrice && matchesRating;
      }).toList();
    });
  }

  void _triggerSearch(String term) {
    _searchController.text = term;
  }

  void _openFiltersSheet() {
    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Filter Products',
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          final sheetTheme = Theme.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Filter Dropdown
              Text('Category', style: sheetTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                items: ['All', ...DummyData.categories.map((c) => c.title)]
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setSheetState(() => _selectedCategory = val);
                    setState(() => _selectedCategory = val);
                    _onSearchChanged();
                  }
                },
              ),
              const SizedBox(height: 20),

              // Price range slider
              Text(
                'Price Range (\$${_priceRange.start.round()} - \$${_priceRange.end.round()})',
                style: sheetTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 500,
                divisions: 50,
                activeColor: sheetTheme.colorScheme.primary,
                labels: RangeLabels('\$${_priceRange.start.round()}', '\$${_priceRange.end.round()}'),
                onChanged: (val) {
                  setSheetState(() => _priceRange = val);
                  setState(() => _priceRange = val);
                  _onSearchChanged();
                },
              ),
              const SizedBox(height: 20),

              // Rating slider
              Text(
                'Minimum Rating (${_minRating == 0 ? "Any" : "${_minRating.toStringAsFixed(1)} ★"})',
                style: sheetTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _minRating,
                min: 0,
                max: 5,
                divisions: 5,
                activeColor: sheetTheme.colorScheme.primary,
                label: '$_minRating Stars',
                onChanged: (val) {
                  setSheetState(() => _minRating = val);
                  setState(() => _minRating = val);
                  _onSearchChanged();
                },
              ),
              const SizedBox(height: 32),

              // Done Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Catalog'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _searchController,
                      labelText: 'Search Products',
                      hintText: 'Type headphones, jacket...',
                      prefixIcon: Icons.search_rounded,
                      showClearButton: true,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filters trigger button
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
                      onPressed: _openFiltersSheet,
                    ),
                  ),
                ],
              ),
            ),

            // Dynamic view based on query state
            Expanded(
              child: !_isSearching
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent searches section
                          if (_recentSearches.isNotEmpty) ...[
                            Text(
                              'Recent Searches',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              children: _recentSearches.map((term) {
                                return ActionChip(
                                  label: Text(term),
                                  onPressed: () => _triggerSearch(term),
                                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),
                          ],

                          // Popular tags section
                          Text(
                            'Popular Categories',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _popularTags.map((tag) {
                              return ActionChip(
                                label: Text(tag),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.categoryProducts,
                                    arguments: tag,
                                  );
                                },
                                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                      ? const EmptyState(
                          icon: Icons.find_in_page_outlined,
                          title: 'No Matches Found',
                          description: 'We couldn\'t find any matches. Try modifying keywords or adjusting filters.',
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _searchResults.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final product = _searchResults[index];
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
      ),
    );
  }
}
