import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/custom_app_bar.dart';
import './widgets/barcode_scanner_view.dart';

class AdminBarcodeScannerScreen extends StatelessWidget {
  const AdminBarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Inventory Scan',
        showBackButton: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          final loading = snapshot.connectionState == ConnectionState.waiting;
          final products = snapshot.data?.docs ?? [];
          return BarcodeScannerView(
            products: products,
            loading: loading,
          );
        },
      ),
    );
  }
}