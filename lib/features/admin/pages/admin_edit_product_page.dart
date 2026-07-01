import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';

class AdminEditProductPage extends StatefulWidget {
  final String productId;

  const AdminEditProductPage({super.key, required this.productId});

  @override
  State<AdminEditProductPage> createState() => _AdminEditProductPageState();
}

class _AdminEditProductPageState extends State<AdminEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late DummyProduct _product;

  late TextEditingController _titleController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _product = DummyData.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => DummyData.products.first,
    );

    _titleController = TextEditingController(text: _product.title);
    _skuController = TextEditingController(text: _product.sku);
    _barcodeController = TextEditingController(text: _product.barcode);
    _descriptionController = TextEditingController(text: _product.description);
    _priceController = TextEditingController(text: _product.price.toString());
    _stockController = TextEditingController(text: _product.stock.toString());
    _selectedCategory = _product.category;
  }

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

  void _onSaveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulated saving delays
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          final index = DummyData.products.indexWhere((p) => p.id == widget.productId);
          if (index != -1) {
            final updatedProduct = DummyProduct(
              id: _product.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              imageUrl: _product.imageUrl,
              price: double.parse(_priceController.text.trim()),
              rating: _product.rating,
              reviewsCount: _product.reviewsCount,
              category: _selectedCategory,
              sku: _skuController.text.trim().toUpperCase(),
              barcode: _barcodeController.text.trim(),
              stock: int.parse(_stockController.text.trim()),
            );
            setState(() {
              DummyData.products[index] = updatedProduct;
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Changes to "${updatedProduct.title}" saved successfully!'),
                backgroundColor: Colors.teal,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Product Details',
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
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter SKU' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _barcodeController,
                        labelText: 'Barcode GTIN',
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
                        labelText: 'Stock Units',
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
                  keyboardType: TextInputType.multiline,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 36),

                // Save Action Button
                CustomButton(
                  text: 'Save Changes',
                  isLoading: _isLoading,
                  onPressed: _onSaveChanges,
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
