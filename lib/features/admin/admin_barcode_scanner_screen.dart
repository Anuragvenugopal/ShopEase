import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/dummy_data.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';

class AdminBarcodeScannerScreen extends StatefulWidget {
  const AdminBarcodeScannerScreen({super.key});

  @override
  State<AdminBarcodeScannerScreen> createState() => _AdminBarcodeScannerScreenState();
}

class _AdminBarcodeScannerScreenState extends State<AdminBarcodeScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;
  bool _flashActive = false;

  @override
  void initState() {
    super.initState();

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _triggerMockScan() {
    // 1. Activate Flash Overlay animation
    setState(() {
      _flashActive = true;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _flashActive = false;
        });

        // 2. Select a random product to simulate scanner reading GTIN
        final rand = Random();
        final scannedProduct = DummyData.products[rand.nextInt(DummyData.products.length)];

        // 3. Open inventory updater sheet
        _showScannedProductSheet(scannedProduct);
      }
    });
  }

  void _showScannedProductSheet(DummyProduct product) {
    final stockController = TextEditingController(text: product.stock.toString());
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Barcode Read: Success!',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scanned product overview card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text('GTIN Barcode: ${product.barcode}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stock Replenish Input
            CustomTextField(
              controller: stockController,
              labelText: 'Update Total Stock Units',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter quantity';
                final n = int.tryParse(v.trim());
                if (n == null || n < 0) return 'Enter valid stock count';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save details
            CustomButton(
              text: 'Confirm Inventory Change',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newStock = int.parse(stockController.text.trim());
                  setState(() {
                    product.stock = newStock;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Stock count updated to $newStock for "${product.title}"'),
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
        title: 'Inventory Scan',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Background camera viewport preview simulation (dark gray card)
          Container(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
            width: double.infinity,
            height: double.infinity,
          ),

          // Central scan crosshairs box
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Looping Red Laser scanner line
                  AnimatedBuilder(
                    animation: _laserAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 260 * _laserAnimation.value,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Crosshairs Corner markers
                  _buildCornerMarker(top: 10, left: 10),
                  _buildCornerMarker(top: 10, right: 10),
                  _buildCornerMarker(bottom: 10, left: 10),
                  _buildCornerMarker(bottom: 10, right: 10),
                ],
              ),
            ),
          ),

          // Viewfinder help text overlay
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Position product barcode inside the viewfinder crosshairs to scan.',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Trigger simulated scan button
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Column(
              children: [
                CustomButton(
                  text: 'Simulate Code Read',
                  icon: Icons.flash_on_rounded,
                  onPressed: _triggerMockScan,
                ),
                const SizedBox(height: 12),
                Text(
                  'Simulates hardware barcode scanning using catalog data',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                ),
              ],
            ),
          ),

          // White flash screen overlay animation
          if (_flashActive)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.85),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCornerMarker({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border(
            top: top != null ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            bottom: bottom != null ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            left: left != null ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            right: right != null ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}