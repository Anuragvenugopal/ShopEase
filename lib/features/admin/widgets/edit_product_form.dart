import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../presentation/blocs/product/product_bloc.dart';
import '../../../presentation/blocs/product/product_event.dart';
import '../../../presentation/blocs/product/product_state.dart';

class EditProductForm extends StatefulWidget {
  final String productId;

  const EditProductForm({super.key, required this.productId});

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  late ProductEntity _product;
  bool _initialized = false;

  late TextEditingController _titleController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _selectedCategory;
  bool _isLoading = false;
  XFile? _pickedImage;
  bool _isActive = true;

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

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    final productState = context.read<ProductBloc>().state;
    if (productState is ProductsLoaded) {
      final product = productState.products.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => productState.products.first,
      );
      _setupControllers(product);
    } else {
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get()
          .then((doc) {
            if (doc.exists && doc.data() != null && mounted) {
              final data = doc.data()!;
              final product = ProductEntity(
                id: doc.id,
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                imageUrl: data['imageUrl'] ?? '',
                price: (data['price'] as num?)?.toDouble() ?? 0.0,
                originalPrice: (data['originalPrice'] as num?)?.toDouble(),
                offerPercentage: (data['offerPercentage'] as num?)?.toInt(),
                rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
                reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
                category: data['category'] ?? '',
                sku: data['sku'] ?? '',
                barcode: data['barcode'] ?? '',
                stock: (data['stock'] as num?)?.toInt() ?? 0,
                isActive: data['isActive'] as bool? ?? true,
              );
              _setupControllers(product);
            }
          });
    }
  }

  void _setupControllers(ProductEntity product) {
    _product = product;
    _titleController = TextEditingController(text: product.title);
    _skuController = TextEditingController(text: product.sku);
    _barcodeController = TextEditingController(text: product.barcode);
    _descriptionController = TextEditingController(text: product.description);
    _priceController = TextEditingController(text: product.price.toString());
    _stockController = TextEditingController(text: product.stock.toString());
    _selectedCategory = product.category;
    _isActive = product.isActive;
    setState(() {
      _initialized = true;
    });
  }

  @override
  void dispose() {
    if (_initialized) {
      _titleController.dispose();
      _skuController.dispose();
      _barcodeController.dispose();
      _descriptionController.dispose();
      _priceController.dispose();
      _stockController.dispose();
    }
    super.dispose();
  }

  void _onSaveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String downloadUrl = _product.imageUrl;
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

      final updatedProduct = ProductEntity(
        id: _product.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: downloadUrl,
        price: double.parse(_priceController.text.trim()),
        originalPrice: _product.originalPrice,
        offerPercentage: _product.offerPercentage,
        rating: _product.rating,
        reviewsCount: _product.reviewsCount,
        category: _selectedCategory,
        sku: _skuController.text.trim().toUpperCase(),
        barcode: _barcodeController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        isActive: _isActive,
      );

      if (mounted) {
        context.read<ProductBloc>().add(UpdateProduct(updatedProduct));
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Changes to "${updatedProduct.title}" saved successfully!',
              ),
              backgroundColor: Colors.teal,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Product ID (read-only, from Firestore) ─────────────────
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
                          'Product ID',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.productId,
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
                      Clipboard.setData(ClipboardData(text: widget.productId));
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
                    : _product.imageUrl.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: _product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline),
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
                            'Tap to Edit Product Image',
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
              prefixIcon: Icons.shopping_bag_outlined,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter product name'
                  : null,
            ),
            const SizedBox(height: 18),

            // Category selector dropdown
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
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                );
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
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter SKU' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _barcodeController,
                    labelText: 'Barcode GTIN',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter barcode' : null,
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
                    labelText: 'Base Price (₹)',
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
                    labelText: 'Stock Units',
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

            // Description Field
            CustomTextField(
              controller: _descriptionController,
              labelText: 'Product Description',
              keyboardType: TextInputType.multiline,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter description'
                  : null,
            ),
            const SizedBox(height: 18),

            // Switch for Enabling/Disabling Product
            SwitchListTile(
              title: const Text('Product Active Status'),
              subtitle: Text(
                _isActive 
                  ? 'Product is enabled and visible to customers' 
                  : 'Product is disabled and hidden from storefront'
              ),
              value: _isActive,
              activeColor: theme.colorScheme.primary,
              onChanged: (bool value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const SizedBox(height: 24),

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
    );
  }
}
