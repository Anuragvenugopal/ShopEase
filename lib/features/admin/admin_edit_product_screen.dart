import 'package:flutter/material.dart';
import '../../core/widgets/custom_app_bar.dart';
import './widgets/edit_product_form.dart';

class AdminEditProductScreen extends StatelessWidget {
  final String productId;

  const AdminEditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Product Details',
        showBackButton: true,
      ),
      body: SafeArea(
        child: EditProductForm(productId: productId),
      ),
    );
  }
}