import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/dummy_data.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';

class AdminLowStockScreen extends StatefulWidget {
  const AdminLowStockScreen({super.key});

  @override
  State<AdminLowStockScreen> createState() => _AdminLowStockScreenState();
}

class _AdminLowStockScreenState extends State<AdminLowStockScreen> {
  late List<DummyProduct> _lowStockProducts;

  @override
  void initState() {
    super.initState();
    _loadLowStock();
  }

  void _loadLowStock() {
    setState(() {
      _lowStockProducts = DummyData.products.where((p) => p.stock <= 5).toList();
    });
  }

  void _replenishStock(DummyProduct product) {
    final quantityController = TextEditingController(text: '20');
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Replenish Inventory',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add stock units for: "${product.title}"',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: quantityController,
              labelText: 'Units to Add',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter quantity';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Enter valid positive number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Add Units to Stock',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final addedAmount = int.parse(quantityController.text.trim());
                  setState(() {
                    product.stock += addedAmount;
                  });
                  _loadLowStock(); // reload low stock items
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $addedAmount units. Stock is now ${product.stock}.'),
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
        title: 'Replenish Center',
        showBackButton: true,
      ),
      body: SafeArea(
        child: _lowStockProducts.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 64, color: theme.colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text(
                        'Inventory Fully Stocked!',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'All catalog products exceed the minimum threshold stock level limit (5 units).',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  // Alert Banner Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: theme.colorScheme.tertiary.withOpacity(0.08),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: theme.colorScheme.tertiary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Warning: ${_lowStockProducts.length} products fell under stock limits of 5.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Low stock catalog items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _lowStockProducts.length,
                      itemBuilder: (context, index) {
                        final product = _lowStockProducts[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: product.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Details
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
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('SKU: ', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
                                            Text(product.sku, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              'Current Stock: ',
                                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                            ),
                                            Text(
                                              '${product.stock} units',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.tertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),

                              // Quick replenish button
                              CustomButton(
                                text: 'Replenish Inventory Units',
                                icon: Icons.inventory_2_outlined,
                                height: 42,
                                onPressed: () => _replenishStock(product),
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