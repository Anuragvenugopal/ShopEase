import 'package:cached_network_image/cached_network_image.dart';
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

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  final _searchController = TextEditingController();

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

  void _deleteProduct(ProductEntity product) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Product',
      content: 'Are you sure you want to delete "${product.title}"? This will permanently remove the item from the catalog.',
      confirmText: 'Delete permanent',
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final productState = context.watch<ProductBloc>().state;
    final List<ProductEntity> allProducts =
        productState is ProductsLoaded ? productState.products : [];

    final query = _searchController.text.trim().toLowerCase();
    final filteredProducts = query.isEmpty
        ? allProducts
        : allProducts
            .where((p) =>
                p.title.toLowerCase().contains(query) ||
                p.sku.toLowerCase().contains(query))
            .toList();

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
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                controller: _searchController,
                labelText: 'Search Catalog',
                hintText: 'Enter name or SKU...',
                prefixIcon: Icons.search_rounded,
                showClearButton: true,
              ),
            ),

            // Products Table List
            Expanded(
              child: productState is ProductLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products found matching query.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
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
                                  color: isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.black.withOpacity(0.04),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Image Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: product.imageUrl,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
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
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('SKU: ',
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(fontSize: 11)),
                                            Text(product.sku,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${product.price.toStringAsFixed(0)}',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: (isLowStock
                                                        ? theme.colorScheme
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
                                                          .colorScheme.tertiary
                                                      : Colors.teal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Actions Row
                                  Row(
                                    children: [
                                      // Edit Button
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined,
                                            color: theme.colorScheme.primary,
                                            size: 20),
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
                                        icon: Icon(Icons.delete_outline_rounded,
                                            color: theme.colorScheme.tertiary,
                                            size: 20),
                                        onPressed: () =>
                                            _deleteProduct(product),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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