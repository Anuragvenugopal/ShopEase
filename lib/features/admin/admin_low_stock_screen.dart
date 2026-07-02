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

class AdminLowStockScreen extends StatelessWidget {
  const AdminLowStockScreen({super.key});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _replenishStock(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String title = data['title'] ?? '';
    final int stock = (data['stock'] as num?)?.toInt() ?? 0;

    final quantityController = TextEditingController(text: stock.toString());
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
              'Update stock units for: "$title"',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: quantityController,
              labelText: 'Total Stock Units (Current: $stock)',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter stock quantity';
                final n = int.tryParse(v.trim());
                if (n == null || n < 0) return 'Enter valid stock count';
                return null;
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Confirm Inventory Change',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newStock = int.parse(quantityController.text.trim());

                  await _firestore.collection('products').doc(doc.id).update({'stock': newStock});

                  if (context.mounted) {
                    context.read<ProductBloc>().add(LoadProducts());
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stock count updated to $newStock for "$title"'),
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
        title: 'Replenish Center',
        showBackButton: true,
      ),
      body: SafeArea(
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
            final lowStockProducts = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final stock = (data['stock'] as num?)?.toInt() ?? 0;
              return stock <= 5;
            }).toList();

            if (lowStockProducts.isEmpty) {
              return Center(
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
              );
            }

            return Column(
              children: [
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: theme.colorScheme.tertiary.withOpacity(0.08),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: theme.colorScheme.tertiary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Warning: ${lowStockProducts.length} products fell under stock limits of 5.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lowStockProducts.length,
                    itemBuilder: (context, index) {
                      final doc = lowStockProducts[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final String title = data['title'] ?? '';
                      final String imageUrl = data['imageUrl'] ?? '';
                      final String sku = data['sku'] ?? '';
                      final int stock = (data['stock'] as num?)?.toInt() ?? 0;

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
                                
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imageUrl.startsWith('http')
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image, size: 60),
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
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('SKU: ', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10)),
                                          Text(sku, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            'Current Stock: ',
                                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                                          ),
                                          Text(
                                            '$stock units',
                                            style: TextStyle(
                                              fontSize: 11,
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

                            
                            CustomButton(
                              text: 'Replenish Inventory Units',
                              icon: Icons.add_circle_outline_rounded,
                              height: 38,
                              fontSize: 12,
                              onPressed: () => _replenishStock(context, doc),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}