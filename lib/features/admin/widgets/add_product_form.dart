import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../presentation/blocs/product/product_bloc.dart';
import '../../../presentation/blocs/product/product_event.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  /// Auto-generated Firestore-style 20-char alphanumeric product ID.
  late final String _autoProductId;

  final _titleController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String _selectedCategory = 'Electronics';
  bool _isLoading = false;
  XFile? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  /// Generates a 20-character Firestore-compatible document ID.
  static String _generateFirestoreId() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(20, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _generateSku(String category) {
    final prefix = category.length >= 3
        ? category.substring(0, 3).toUpperCase()
        : 'PRD';
    final randNum = Random().nextInt(900) + 100; // 100-999
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rand = Random();
    final randChar =
        chars[rand.nextInt(chars.length)] + chars[rand.nextInt(chars.length)];
    return '$prefix-$randChar-$randNum';
  }

  String _generateBarcode() {
    final rand = Random();
    return List.generate(8, (_) => rand.nextInt(10).toString()).join();
  }

  @override
  void initState() {
    super.initState();
    _autoProductId = _generateFirestoreId();
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

  void _onSaveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String downloadUrl =
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80';
      if (_pickedImage != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('products')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await storageRef.putData(await _pickedImage!.readAsBytes());
          downloadUrl = await storageRef.getDownloadURL();
        } catch (e) {
          setState(() => _isLoading = false);
          if (mounted) {
            CustomToast.show(
              context,
              'Upload failed: Please check Storage setup / billing on Firebase Console.',
            );
          }
          return;
        }
      }

      final newProduct = ProductEntity(
        id: _autoProductId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: downloadUrl,
        price: double.parse(_priceController.text.trim()),
        rating: 4.5,
        reviewsCount: 0,
        category: _selectedCategory,
        sku: _skuController.text.trim().toUpperCase(),
        barcode: _barcodeController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
      );

      if (mounted) {
        context.read<ProductBloc>().add(AddProduct(newProduct));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${newProduct.title}" added successfully!'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() => _isLoading = false);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Auto-generated Product ID (read-only) ──────────────────
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.07),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product ID  (auto-generated)',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _autoProductId,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    tooltip: 'Copy ID',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _autoProductId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ── Image Upload Area ───────────────────────────────────────
            InkWell(
              onTap: _isLoading ? null : _pickImage,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF161F30)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                  ),
                ),
                child: _pickedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: kIsWeb
                                ? Image.network(
                                    _pickedImage!.path,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 38,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to Upload Product Image (Optional)',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Supports PNG, JPG, JPEG',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Product Title ───────────────────────────────────────────
            CustomTextField(
              controller: _titleController,
              labelText: 'Product Name',
              hintText: 'Enter title...',
              prefixIcon: Icons.shopping_bag_outlined,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter product name'
                  : null,
            ),
            const SizedBox(height: 18),

            // ── Category Dropdown ───────────────────────────────────────
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                List<String> categoriesList = [
                  'Fashion',
                  'Electronics',
                  'Home Decor',
                  'Beauty',
                  'Sports',
                ];
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  categoriesList = snapshot.data!.docs
                      .map(
                        (doc) =>
                            (doc.data() as Map<String, dynamic>)['name']
                                as String,
                      )
                      .toList();
                }

                String activeCategory = _selectedCategory;
                if (!categoriesList.contains(activeCategory) &&
                    categoriesList.isNotEmpty) {
                  activeCategory = categoriesList.first;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _selectedCategory = activeCategory;
                      });
                    }
                  });
                }

                return DropdownButtonFormField<String>(
                  value: categoriesList.contains(activeCategory)
                      ? activeCategory
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF161F30) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: categoriesList
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 18),

            // ── SKU & Barcode ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _skuController,
                    labelText: 'SKU Code',
                    hintText: 'ELE-HP-001',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.autorenew_rounded, size: 20),
                      tooltip: 'Generate SKU',
                      onPressed: () {
                        _skuController.text = _generateSku(_selectedCategory);
                      },
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter SKU' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _barcodeController,
                    labelText: 'Barcode GTIN',
                    hintText: '88094235',
                    keyboardType: TextInputType.number,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.autorenew_rounded, size: 20),
                      tooltip: 'Generate Barcode',
                      onPressed: () {
                        _barcodeController.text = _generateBarcode();
                      },
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter barcode' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Price & Stock ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _priceController,
                    labelText: 'Base Price (\$)',
                    hintText: '19.99',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter price';
                      if (double.tryParse(v.trim()) == null)
                        return 'Invalid price';
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
                      if (int.tryParse(v.trim()) == null)
                        return 'Invalid integer';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Description ─────────────────────────────────────────────
            CustomTextField(
              controller: _descriptionController,
              labelText: 'Product Description',
              hintText: 'Enter features, specifications...',
              keyboardType: TextInputType.multiline,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter description'
                  : null,
            ),
            const SizedBox(height: 36),

            // ── Save Button ─────────────────────────────────────────────
            CustomButton(
              text: 'Save to Catalog',
              isLoading: _isLoading,
              onPressed: _onSaveProduct,
              icon: Icons.check_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
