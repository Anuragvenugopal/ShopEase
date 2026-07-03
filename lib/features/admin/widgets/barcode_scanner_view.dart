import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../presentation/blocs/product/product_bloc.dart';
import '../../../presentation/blocs/product/product_event.dart';

class BarcodeScannerView extends StatefulWidget {
  final List<DocumentSnapshot> products;
  final bool loading;

  const BarcodeScannerView({
    super.key,
    required this.products,
    required this.loading,
  });

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() => _isProcessing = true);

    // Pause scanner while showing result
    _cameraController.stop();

    // Try to find matching product by barcode field
    DocumentSnapshot? matchedDoc;
    try {
      matchedDoc = widget.products.firstWhere((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final barcode = (data['barcode'] ?? '').toString();
        return barcode == rawValue;
      });
    } catch (_) {
      matchedDoc = null;
    }

    if (matchedDoc != null) {
      _showScannedProductSheet(matchedDoc, rawValue);
    } else {
      // No matching product found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No product found for barcode: $rawValue'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isProcessing = false);
          _cameraController.start();
        }
      });
    }
  }

  void _showScannedProductSheet(DocumentSnapshot doc, String scannedBarcode) {
    final data = doc.data() as Map<String, dynamic>;
    final String title = data['title'] ?? '';
    final String imageUrl = data['imageUrl'] ?? '';
    final String barcode = data['barcode'] ?? scannedBarcode;
    final int currentStock = (data['stock'] as num?)?.toInt() ?? 0;

    final stockController = TextEditingController(text: currentStock.toString());
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Barcode Read: Success!',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 50),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Barcode GTIN: $barcode',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            CustomButton(
              text: 'Confirm Inventory Change',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newStock = int.parse(stockController.text.trim());
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(doc.id)
                      .update({'stock': newStock});

                  if (mounted) {
                    context.read<ProductBloc>().add(LoadProducts());
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Stock updated to $newStock for "$title"',
                        ),
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
    ).then((_) {
      // Resume scanner when sheet is dismissed
      if (mounted) {
        setState(() => _isProcessing = false);
        _cameraController.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Live camera feed
        MobileScanner(
          controller: _cameraController,
          onDetect: widget.loading ? null : _onDetect,
        ),

        // Overlay dimming + viewfinder
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.45),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Viewfinder border
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),

        // Instruction banner
        Positioned(
          top: 60,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.loading
                  ? 'Loading product database...'
                  : 'Point the camera at a product barcode to scan.',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Flash toggle button
        Positioned(
          bottom: 48,
          left: 32,
          right: 32,
          child: CustomButton(
            text: 'Toggle Flash',
            icon: Icons.flash_on_rounded,
            onPressed: () => _cameraController.toggleTorch(),
          ),
        ),
      ],
    );
  }
}
