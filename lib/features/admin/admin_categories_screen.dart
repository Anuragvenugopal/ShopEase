import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/dummy_data.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/confirmation_dialog.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  // Mock child nodes / subcategories list matching categories
  final Map<String, List<String>> _subcategories = {
    'Fashion': ['Men\'s Wear', 'Women\'s Wear', 'Kids', 'Footwear'],
    'Electronics': ['Smartphones', 'Laptops', 'Audio Headphones', 'Smart Watches'],
    'Home Decor': ['Vases', 'Wall Mirrors', 'Lamps', 'Clocks'],
    'Beauty': ['Skin Care', 'Make Up', 'Hair Care', 'Perfumes'],
    'Sports': ['Rackets', 'Gym Gear', 'Footballs', 'Dumbbells'],
  };

  void _deleteCategory(DummyCategory cat) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Category',
      content: 'Are you sure you want to delete "${cat.title}"? All subcategory links will be severed.',
      confirmText: 'Delete Category',
      isDangerous: true,
      onConfirm: () {
        setState(() {
          DummyData.categories.removeWhere((c) => c.id == cat.id);
          _subcategories.remove(cat.title);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${cat.title}" category deleted successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _openAddCategorySheet() {
    final titleController = TextEditingController();
    final subcategoriesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ConfirmationDialog.showActionBottomSheet(
      context,
      title: 'Create Category',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: titleController,
              labelText: 'Category Title',
              hintText: 'e.g. Toys',
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter category title' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: subcategoriesController,
              labelText: 'Subcategories (comma separated)',
              hintText: 'e.g. Board Games, Action Figures',
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter subcategories' : null,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Category',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final title = titleController.text.trim();
                  final subs = subcategoriesController.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  setState(() {
                    DummyData.categories.add(
                      DummyCategory(
                        id: 'cat${DummyData.categories.length + 1}',
                        title: title,
                        imageUrl: 'https://images.unsplash.com/photo-1537726251274-b413da5dfe4e?auto=format&fit=crop&w=200&q=80',
                      ),
                    );
                    _subcategories[title] = subs;
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$title" category added successfully!'),
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
      appBar: CustomAppBar(
        title: 'Manage Categories',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: _openAddCategorySheet,
          ),
        ],
      ),
      body: SafeArea(
        child: DummyData.categories.isEmpty
            ? Center(
                child: Text('No categories registered.', style: theme.textTheme.bodyMedium),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: DummyData.categories.length,
                itemBuilder: (context, index) {
                  final cat = DummyData.categories[index];
                  final subs = _subcategories[cat.title] ?? [];

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
                        child: CachedNetworkImage(
                          imageUrl: cat.imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cat.title,
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text('${subs.length} subcategories active', style: const TextStyle(fontSize: 11)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.tertiary, size: 20),
                            onPressed: () => _deleteCategory(cat),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Child Subcategory Nodes:',
                            style: theme.textTheme.titleMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: subs.map((s) {
                              return Chip(
                                label: Text(s, style: const TextStyle(fontSize: 11)),
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide.none,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}