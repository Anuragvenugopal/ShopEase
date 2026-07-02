import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../domain/entities/product_entity.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/product/product_event.dart';
import '../../presentation/blocs/product/product_state.dart';

class AdminProductListScreen extends StatelessWidget {
  final ValueNotifier<String> _searchQuery = ValueNotifier('');
  final ValueNotifier<String> _selectedCategory = ValueNotifier('All');
  final ValueNotifier<bool> _isInit = ValueNotifier(true);

  AdminProductListScreen({super.key});

  void _deleteProduct(BuildContext context, ProductEntity product) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Product',
      content:
          'Are you sure you want to delete "${product.title}"? This will permanently remove the item from the catalog.',
      confirmText: 'Delete',
      isDangerous: true,
      onConfirm: () {
        context.read<ProductBloc>().add(DeleteProduct(product.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${product.title}" deleted successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit.value) {
      final String? initialCategory =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (initialCategory != null) {
        _selectedCategory.value = initialCategory;
      }
      _isInit.value = false;

      // Dispatch LoadProducts if initial or not loaded
      final productState = context.read<ProductBloc>().state;
      if (productState is! ProductsLoaded) {
        context.read<ProductBloc>().add(LoadProducts());
      }
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Catalog List',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.adminAddProduct);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search textfield
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: CustomTextField(
                labelText: 'Search Catalog',
                hintText: 'Enter name or SKU...',
                prefixIcon: Icons.search_rounded,
                showClearButton: true,
                onChanged: (val) {
                  _searchQuery.value = val.trim();
                },
              ),
            ),

            // Category choice chips filter
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                final categoriesDocs = snapshot.data!.docs;
                final List<String> categories = ['All'];
                for (var doc in categoriesDocs) {
                  final nameData = doc.data() as Map<String, dynamic>;
                  final catName = nameData['name'] as String?;
                  if (catName != null && !categories.contains(catName)) {
                    categories.add(catName);
                  }
                }

                return ValueListenableBuilder<String>(
                  valueListenable: _selectedCategory,
                  builder: (context, currentCat, _) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        children: categories.map((cat) {
                          final isSelected = currentCat == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  _selectedCategory.value = cat;
                                }
                              },
                              backgroundColor: isDark
                                  ? const Color(0xFF161F30)
                                  : Colors.white,
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),

            // Products Table List
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, productState) {
                  if (productState is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<ProductEntity> allProducts =
                      productState is ProductsLoaded
                      ? productState.products
                      : [];

                  return ValueListenableBuilder<String>(
                    valueListenable: _selectedCategory,
                    builder: (context, selectedCat, _) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _searchQuery,
                        builder: (context, query, _) {
                          final queryLower = query.toLowerCase();
                          final filteredProducts = queryLower.isEmpty
                              ? allProducts
                              : allProducts
                                    .where(
                                      (p) =>
                                          p.title.toLowerCase().contains(
                                            queryLower,
                                          ) ||
                                          p.sku.toLowerCase().contains(
                                            queryLower,
                                          ) ||
                                          p.barcode.toLowerCase().contains(
                                            queryLower,
                                          ),
                                    )
                                    .toList();

                          final displayedProducts = selectedCat == 'All'
                              ? filteredProducts
                              : filteredProducts
                                    .where(
                                      (p) =>
                                          p.category.toLowerCase() ==
                                          selectedCat.toLowerCase(),
                                    )
                                    .toList();

                          if (displayedProducts.isEmpty) {
                            return Center(
                              child: Text(
                                'No products found matching filters.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: displayedProducts.length,
                            itemBuilder: (context, index) {
                              final product = displayedProducts[index];
                              final isLowStock = product.stock <= 5;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF161F30)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: product.isActive
                                        ? (isDark
                                              ? Colors.white.withOpacity(0.06)
                                              : Colors.black.withOpacity(0.04))
                                        : Colors.orange.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Image Thumbnail
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: ColorFiltered(
                                            colorFilter: product.isActive
                                                ? const ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.multiply,
                                                  )
                                                : const ColorFilter.mode(
                                                    Colors.grey,
                                                    BlendMode.saturation,
                                                  ),
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrl,
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (!product.isActive)
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color: Colors.black54,
                                              padding: const EdgeInsets.all(2),
                                              child: const Text(
                                                'DISABLED',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 14),

                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: product.isActive
                                                      ? null
                                                      : theme
                                                            .colorScheme
                                                            .onSurface
                                                            .withOpacity(0.4),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                'SKU: ',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(fontSize: 11),
                                              ),
                                              Text(
                                                product.sku,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '₹${product.price.toStringAsFixed(0)}',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme
                                                          .colorScheme
                                                          .primary,
                                                      fontSize: 13,
                                                    ),
                                              ),
                                              const SizedBox(width: 14),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      (isLowStock
                                                              ? theme
                                                                    .colorScheme
                                                                    .tertiary
                                                              : Colors.teal)
                                                          .withOpacity(0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Stock: ${product.stock}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: isLowStock
                                                        ? theme
                                                              .colorScheme
                                                              .tertiary
                                                        : Colors.teal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),

                                    // Actions Column
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Enable/Disable toggle
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Switch(
                                            value: product.isActive,
                                            activeColor:
                                                theme.colorScheme.primary,
                                            onChanged: (val) async {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(product.id)
                                                  .update({'isActive': val});
                                              if (context.mounted) {
                                                context.read<ProductBloc>().add(
                                                  LoadProducts(),
                                                );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '"${product.title}" ${val ? 'enabled' : 'disabled'}.',
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Edit Button
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color:
                                                    theme.colorScheme.primary,
                                                size: 19,
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.adminEditProduct,
                                                  arguments: product.id,
                                                );
                                              },
                                            ),
                                            // Delete Button
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_outline_rounded,
                                                color:
                                                    theme.colorScheme.tertiary,
                                                size: 19,
                                              ),
                                              onPressed: () => _deleteProduct(
                                                context,
                                                product,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
