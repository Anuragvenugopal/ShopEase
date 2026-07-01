import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/routes/app_routes.dart';
import './category_card.dart';

/// Horizontal scrollable list of [CategoryCard]s built from Firestore categories.
class HomeCategoryList extends StatelessWidget {
  const HomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 98,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Shimmer.fromColors(
              baseColor: isDark ? const Color(0xFF1E293B) : Colors.grey[300]!,
              highlightColor: isDark ? const Color(0xFF334155) : Colors.grey[100]!,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 48,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No categories'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['name'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CategoryCard(
                  title: title,
                  imageUrl: imageUrl,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.categoryProducts,
                      arguments: title,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
