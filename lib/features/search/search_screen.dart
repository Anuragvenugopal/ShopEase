import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/custom_toast.dart';
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  // Active Filters
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(10, 500);
  double _minRating = 0.0;

  final List<String> _recentSearches = ['Headphones', 'Jacket', 'Face Serum'];
  final List<String> _popularTags = [
    'Electronics',
    'Fashion',
    'Beauty',
    'Sports',
    'Decor'
  ];

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
    setState(() {});
  }

  void _triggerSearch(String term) {
    _searchController.text = term;
  }

  void _openFiltersSheet(List<String> categories) {
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
              const AppText('Category',
                  variant: AppTextVariant.titleMedium, bold: true),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                items: ['All', ...categories]
                    .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: AppText(cat, variant: AppTextVariant.bodyMedium)))
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
              AppText(
                'Price Range (₹${_priceRange.start.round()} - ₹${_priceRange.end.round()})',
                variant: AppTextVariant.titleMedium,
                bold: true,
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 500,
                divisions: 50,
                activeColor: sheetTheme.colorScheme.primary,
                labels: RangeLabels('₹${_priceRange.start.round()}',
                    '₹${_priceRange.end.round()}'),
                onChanged: (val) {
                  setSheetState(() => _priceRange = val);
                  setState(() => _priceRange = val);
                  _onSearchChanged();
                },
              ),
              const SizedBox(height: 20),

              // Rating slider
              AppText(
                'Minimum Rating (${_minRating == 0 ? "Any" : "${_minRating.toStringAsFixed(1)} ★"})',
                variant: AppTextVariant.titleMedium,
                bold: true,
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
                child: const AppText('Apply Filters',
                    variant: AppTextVariant.bodyLarge,
                    bold: true,
                    color: Colors.white),
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

    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    final productState = context.watch<ProductBloc>().state;
    final wishlistState = context.watch<WishlistBloc>().state;

    final List<ProductEntity> allProducts =
        productState is ProductsLoaded ? productState.products : [];
    final Set<String> wishlistedIds = wishlistState is WishlistLoaded
        ? wishlistState.wishlistedIds
        : <String>{};

    final List<String> categories =
        allProducts.map((p) => p.category).toSet().toList();

    final query = _searchController.text.trim().toLowerCase();
    final bool isSearching = query.isNotEmpty;

    final List<ProductEntity> searchResults = isSearching
        ? allProducts.where((product) {
            final matchesQuery = product.title.toLowerCase().contains(query) ||
                product.description.toLowerCase().contains(query);
            final matchesCategory = _selectedCategory == 'All' ||
                product.category == _selectedCategory;
            final matchesPrice = product.price >= _priceRange.start &&
                product.price <= _priceRange.end;
            final matchesRating = product.rating >= _minRating;

            return matchesQuery &&
                matchesCategory &&
                matchesPrice &&
                matchesRating;
          }).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const AppText('Search Catalog',
            variant: AppTextVariant.titleLarge, bold: true),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                      color: AppColors.adaptive(
                        isDark: isDark,
                        lightColor: AppColors.searchBarLight,
                        darkColor: AppColors.searchBarDark,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.adaptive(
                          isDark: isDark,
                          lightColor: AppColors.overlayLight,
                          darkColor: AppColors.overlayDark,
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune_rounded,
                          color: theme.colorScheme.primary),
                      onPressed: () => _openFiltersSheet(categories),
                    ),
                  ),
                ],
              ),
            ),

            // Dynamic view based on query state
            Expanded(
              child: !isSearching
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent searches section
                          if (_recentSearches.isNotEmpty) ...[
                            const AppText(
                              'Recent Searches',
                              variant: AppTextVariant.titleMedium,
                              bold: true,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              children: _recentSearches.map((term) {
                                return ActionChip(
                                  label: AppText(term,
                                      variant: AppTextVariant.bodyMedium),
                                  onPressed: () => _triggerSearch(term),
                                  backgroundColor: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),
                          ],

                          // Popular tags section
                          const AppText(
                            'Popular Categories',
                            variant: AppTextVariant.titleMedium,
                            bold: true,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _popularTags.map((tag) {
                              return ActionChip(
                                label: AppText(tag,
                                    variant: AppTextVariant.bodyMedium),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.categoryProducts,
                                    arguments: tag,
                                  );
                                },
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : searchResults.isEmpty
                      ? const EmptyState(
                          icon: Icons.find_in_page_outlined,
                          title: 'No Matches Found',
                          description:
                              'We couldn\'t find any matches. Try modifying keywords or adjusting filters.',
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: searchResults.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.50,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final product = searchResults[index];
                            final isWishlisted =
                                wishlistedIds.contains(product.id);

                            return ProductCard(
                              id: product.id,
                              title: product.title,
                              imageUrl: product.imageUrl,
                              price: product.price,
                              originalPrice: product.originalPrice,
                              rating: product.rating,
                              reviewsCount: product.reviewsCount,
                              initialIsWishlisted: isWishlisted,
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
                                        ToggleWishlist(
                                            userId, product.id, !wishlisted),
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