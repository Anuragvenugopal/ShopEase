import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';
import './widgets/add_category_form.dart';
import './widgets/edit_category_form.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteCategory(BuildContext context, String docId, String title) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Category',
      content: 'Are you sure you want to delete "$title"? All subcategory links will be severed.',
      confirmText: 'Delete Category',
      isDangerous: true,
      onConfirm: () async {
        try {
          await _firestore.collection('categories').doc(docId).delete();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"$title" category deleted successfully.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete: $e'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
    );
  }

  void _openAddCategorySheet(BuildContext context) {
    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Create Category',
      child: const AddCategoryForm(),
    );
  }

  void _openEditCategorySheet(BuildContext context, String docId, String currentName, String currentImageUrl) {
    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Edit Category',
      child: EditCategoryForm(
        docId: docId,
        currentName: currentName,
        currentImageUrl: currentImageUrl,
      ),
    );
  }

  void _addSubcategory(BuildContext context, String docId, List<String> currentSubs) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Add Subcategory',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: controller,
              labelText: 'Subcategory Name',
              hintText: 'e.g. Smart Watches',
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter subcategory name' : null,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Add Subcategory',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newSub = controller.text.trim();
                  if (!currentSubs.contains(newSub)) {
                    final updatedSubs = List<String>.from(currentSubs)..add(newSub);
                    await _firestore.collection('categories').doc(docId).update({
                      'subcategories': updatedSubs,
                    });
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
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
      appBar: CustomAppBar(
        title: 'Manage Categories',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => _openAddCategorySheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No categories registered.',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final docId = doc.id;
                final title = data['name'] ?? data['title'] ?? '';
                final imageUrl = data['imageUrl'] ?? '';

                // Parse subcategories from field
                final List<dynamic> subsRaw = data['subcategories'] ?? [];
                final List<String> subs = subsRaw.map((s) => s.toString()).toList();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.category_outlined, size: 24),
                            )
                          : const Icon(Icons.category_outlined, size: 44),
                    ),
                    title: Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, color: theme.colorScheme.primary, size: 20),
                          onPressed: () => _openEditCategorySheet(context, docId, title, imageUrl),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.tertiary, size: 20),
                          onPressed: () => _deleteCategory(context, docId, title),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.all(16),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Child Subcategory Nodes:',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.add_rounded, size: 14),
                                  label: const Text('Add Sub', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _addSubcategory(context, docId, subs),
                                ),
                                const SizedBox(width: 4),
                                TextButton.icon(
                                  icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                                  label: const Text('View Products', style: TextStyle(fontSize: 11)),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.adminProductList,
                                      arguments: title,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: subs.isEmpty
                            ? const Text(
                                'No subcategories added yet.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: subs.map((s) {
                                  return InputChip(
                                    label: Text(s, style: const TextStyle(fontSize: 11)),
                                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    side: BorderSide.none,
                                    onDeleted: () async {
                                      final updatedSubs = List<String>.from(subs)..remove(s);
                                      await _firestore.collection('categories').doc(docId).update({
                                        'subcategories': updatedSubs,
                                      });
                                    },
                                    deleteIconColor: Colors.redAccent,
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
