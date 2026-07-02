import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/custom_toast.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _titleController = TextEditingController();
  final _subcategoriesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _isLoading = false;
  String? _errorMessage;

  void _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subcategoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              controller: _titleController,
              labelText: 'Category Title',
              hintText: 'e.g. Toys',
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter category title' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _subcategoriesController,
              labelText: 'Subcategories (comma separated)',
              hintText: 'e.g. Board Games, Action Figures',
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter subcategories' : null,
            ),
            const SizedBox(height: 16),
            
            // Image Picker Layout
            InkWell(
              onTap: _isLoading ? null : _pickImage,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
                  ),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
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
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap to Upload Category Image (Optional)',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Supports PNG, JPG, JPEG',
                            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: 'Save Category',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        final title = _titleController.text.trim();
                        final subs = _subcategoriesController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();

                        String imgUrl = 'https://images.unsplash.com/photo-1537726251274-b413da5dfe4e?auto=format&fit=crop&w=200&q=80';

                        if (_pickedImage != null) {
                          try {
                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('categories')
                                .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
                            await storageRef.putData(await _pickedImage!.readAsBytes());
                            imgUrl = await storageRef.getDownloadURL();
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                              _errorMessage = 'Upload failed: Please check Storage setup / billing on Firebase Console.';
                            });
                            return;
                          }
                        }

                        try {
                          final docRef = FirebaseFirestore.instance.collection('categories').doc();
                          await docRef.set({
                            'id': docRef.id,
                            'name': title,
                            'imageUrl': imgUrl,
                            'subcategories': subs,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('"$title" category added successfully!'),
                                backgroundColor: Colors.teal,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() => _isLoading = false);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add category: $e'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
