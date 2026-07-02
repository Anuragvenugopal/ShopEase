import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/product/product_event.dart';

class AdminSkuSearchScreen extends StatelessWidget {
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  AdminSkuSearchScreen({super.key});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _quickUpdateStockPrice(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String sku = data['sku'] ?? '';
    final String title = data['title'] ?? '';
    final double price = (data['price'] as num?)?.toDouble() ?? 0.0;
    final int stock = (data['stock'] as num?)?.toInt() ?? 0;

    final stockController = TextEditingController(text: stock.toString());
    final priceController = TextEditingController(text: price.toString());
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Console Quick Update',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('SKU Code: $sku', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: priceController,
                    labelText: 'Price (₹)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter price' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: stockController,
                    labelText: 'Stock Units',
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter stock' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Inventory Updates',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newPrice = double.parse(priceController.text.trim());
                  final newStock = int.parse(stockController.text.trim());

                  await _firestore.collection('products').doc(doc.id).update({
                    'price': newPrice,
                    'stock': newStock,
                  });

                  if (context.mounted) {
                    context.read<ProductBloc>().add(LoadProducts());
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updates saved for "$title"'),
                        backgroundColor: Colors.teal,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'SKU Code Lookup',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                labelText: 'SKU or Barcode GTIN',
                hintText: 'e.g. ELE-HP-092 or 880942',
                prefixIcon: Icons.search_rounded,
                showClearButton: true,
                onChanged: (val) {
                  _searchQuery.value = val.trim();
                },
              ),
            ),

            // Search results listing
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  return ValueListenableBuilder<String>(
                    valueListenable: _searchQuery,
                    builder: (context, query, _) {
                      final queryLower = query.toLowerCase();

                      if (queryLower.isEmpty) {
                        return Center(
                          child: Text(
                            'Enter a SKU code or barcode GTIN to search.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      }

                      final matchingProducts = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final sku = (data['sku'] as String? ?? '').toLowerCase();
                        final barcode = (data['barcode'] as String? ?? '').toLowerCase();
                        final title = (data['title'] as String? ?? '').toLowerCase();
                        return sku.contains(queryLower) || barcode.contains(queryLower) || title.contains(queryLower);
                      }).toList();

                      if (matchingProducts.isEmpty) {
                        return Center(
                          child: Text(
                            'No items matched SKU/GTIN.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: matchingProducts.length,
                        itemBuilder: (context, index) {
                          final doc = matchingProducts[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final String title = data['title'] ?? '';
                          final String imageUrl = data['imageUrl'] ?? '';
                          final String sku = data['sku'] ?? '';
                          final String barcode = data['barcode'] ?? '';
                          final double price = (data['price'] as num?)?.toDouble() ?? 0.0;
                          final int stock = (data['stock'] as num?)?.toInt() ?? 0;
                          final isLowStock = stock <= 5;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF161F30) : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: imageUrl.startsWith('http')
                                          ? CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons.image, size: 50),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text('SKU: $sku', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                          Text('Barcode: $barcode', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Price: ₹${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Text('Stock: ', style: TextStyle(fontSize: 12)),
                                            Text(
                                              '$stock units',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: isLowStock ? theme.colorScheme.tertiary : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    CustomButton(
                                      text: 'Quick Update',
                                      width: 120,
                                      height: 38,
                                      onPressed: () => _quickUpdateStockPrice(context, doc),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}