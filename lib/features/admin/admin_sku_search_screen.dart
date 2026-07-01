import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/dummy_data.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';

class AdminSkuSearchScreen extends StatefulWidget {
  const AdminSkuSearchScreen({super.key});

  @override
  State<AdminSkuSearchScreen> createState() => _AdminSkuSearchScreenState();
}

class _AdminSkuSearchScreenState extends State<AdminSkuSearchScreen> {
  final _skuController = TextEditingController();
  List<DummyProduct> _matchingProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _skuController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _skuController.removeListener(_onSearchChanged);
    _skuController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _skuController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _matchingProducts = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _matchingProducts = DummyData.products.where((product) {
        final matchesSku = product.sku.toLowerCase().contains(query);
        final matchesBarcode = product.barcode.contains(query);
        return matchesSku || matchesBarcode;
      }).toList();
    });
  }

  void _quickUpdateStockPrice(DummyProduct product) {
    final stockController = TextEditingController(text: product.stock.toString());
    final priceController = TextEditingController(text: product.price.toString());
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Console Quick Update',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('SKU Code: ${product.sku}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: priceController,
                    labelText: 'Price (\$)',
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    product.price = double.parse(priceController.text.trim());
                    product.stock = int.parse(stockController.text.trim());
                  });
                  _onSearchChanged(); // update active lists
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Updates saved for "${product.title}"'),
                      backgroundColor: Colors.teal,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
                controller: _skuController,
                labelText: 'SKU or Barcode GTIN',
                hintText: 'e.g. ELE-HP-092 or 880942',
                prefixIcon: Icons.search_rounded,
                showClearButton: true,
              ),
            ),

            // Search results listing
            Expanded(
              child: !_isSearching
                  ? Center(
                      child: Text(
                        'Enter a SKU code or barcode GTIN to search.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : _matchingProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No items matched SKU/GTIN.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _matchingProducts.length,
                          itemBuilder: (context, index) {
                            final product = _matchingProducts[index];
                            final isLowStock = product.stock <= 5;

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
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text('SKU: ${product.sku}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                            Text('Barcode: ${product.barcode}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
                                          Text('Price: \$${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Text('Stock: ', style: TextStyle(fontSize: 12)),
                                              Text(
                                                '${product.stock} units',
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
                                        onPressed: () => _quickUpdateStockPrice(product),
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