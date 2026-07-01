import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/dummy_data.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../domain/entities/product_entity.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/product/product_event.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({super.key});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String _selectedCategory = 'Electronics';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _onSaveProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newProduct = ProductEntity(
        id: '', // Empty means Firestore will auto-generate
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
        price: double.parse(_priceController.text.trim()),
        rating: 4.5,
        reviewsCount: 0,
        category: _selectedCategory,
        sku: _skuController.text.trim().toUpperCase(),
        barcode: _barcodeController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
      );

      context.read<ProductBloc>().add(AddProduct(newProduct));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${newProduct.title}" added successfully!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add New Product',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Title
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Product Name',
                  hintText: 'Enter title...',
                  prefixIcon: Icons.shopping_bag_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter product name' : null,
                ),
                const SizedBox(height: 18),

                // Category selector dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF161F30) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  items: DummyData.categories
                      .map((cat) => DropdownMenuItem(value: cat.title, child: Text(cat.title)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 18),

                // SKU & Barcode Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _skuController,
                        labelText: 'SKU Code',
                        hintText: 'ELE-HP-001',
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter SKU' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _barcodeController,
                        labelText: 'Barcode GTIN',
                        hintText: '88094235',
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter barcode' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Price & Stock Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        labelText: 'Base Price (\$)',
                        hintText: '19.99',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter price';
                          if (double.tryParse(v.trim()) == null) return 'Invalid price';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _stockController,
                        labelText: 'Initial Stock',
                        hintText: '10',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter stock';
                          if (int.tryParse(v.trim()) == null) return 'Invalid integer';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Description Field
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Product Description',
                  hintText: 'Enter features, specifications...',
                  keyboardType: TextInputType.multiline,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 36),

                // Save Action Button
                CustomButton(
                  text: 'Save to Catalog',
                  isLoading: _isLoading,
                  onPressed: _onSaveProduct,
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}