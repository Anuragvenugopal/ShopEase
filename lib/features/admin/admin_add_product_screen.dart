import 'package:flutter/material.dart';
import '../../core/widgets/custom_app_bar.dart';
import './widgets/add_product_form.dart';

class AdminAddProductScreen extends StatelessWidget {
  const AdminAddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Product',
        showBackButton: true,
      ),
      body: SafeArea(
        child: AddProductForm(),
      ),
    );
  }
}