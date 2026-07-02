import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/dummy_data.dart';
import '../models/product_model.dart';

class PaginatedModelResponse<T> {
  final List<T> items;
  final DocumentSnapshot? lastDoc;
  final bool hasReachedMax;

  PaginatedModelResponse({
    required this.items,
    this.lastDoc,
    required this.hasReachedMax,
  });
}

@injectable
class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource(this._firestore);

  Future<PaginatedModelResponse<ProductModel>> getProducts({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    
    final catSnapshot = await _firestore.collection('categories').get();
    if (catSnapshot.docs.isEmpty) {
      final Map<String, List<String>> initialSubs = {
        'Fashion': ['Men\'s Wear', 'Women\'s Wear', 'Kids', 'Footwear'],
        'Electronics': ['Smartphones', 'Laptops', 'Audio Headphones', 'Smart Watches'],
        'Home Decor': ['Vases', 'Wall Mirrors', 'Lamps', 'Clocks'],
        'Beauty': ['Skin Care', 'Make Up', 'Hair Care', 'Perfumes'],
        'Sports': ['Rackets', 'Gym Gear', 'Footballs', 'Dumbbells'],
      };
      for (final cat in DummyData.categories) {
        final docRef = _firestore.collection('categories').doc();
        await docRef.set({
          'id': docRef.id,
          'name': cat.title,
          'imageUrl': cat.imageUrl,
          'subcategories': initialSubs[cat.title] ?? [],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }

    
    var snapshot = await _firestore.collection('products').get();
    final existingSkus = snapshot.docs
        .map((d) => d.data()['sku'] as String? ?? '')
        .toSet();

    
    bool seeded = false;
    for (final p in DummyData.products) {
      if (!existingSkus.contains(p.sku)) {
        final docRef = _firestore.collection('products').doc();
        await docRef.set({
          'id': docRef.id,
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'originalPrice': p.originalPrice,
          'offerPercentage': p.originalPrice != null
              ? (((p.originalPrice! - p.price) / p.originalPrice!) * 100).round()
              : null,
          'rating': p.rating,
          'reviewsCount': p.reviewsCount,
          'category': p.category,
          'sku': p.sku,
          'barcode': p.barcode,
          'stock': p.stock,
          'reviews': [
            {
              'name': 'Sarah Jenkins',
              'rating': 5.0,
              'text': 'Absolutely love the build quality! Highly recommended!',
            },
            {
              'name': 'Michael Miller',
              'rating': 4.0,
              'text': 'Great value for money. Would buy again.',
            }
          ],
          'timestamp': FieldValue.serverTimestamp(),
        });
        seeded = true;
      }
    }

    Query query = _firestore.collection('products')
        .orderBy(FieldPath.documentId)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();
    final items = querySnapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();

    final hasReachedMax = items.length < limit;
    final lastDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    return PaginatedModelResponse(
      items: items,
      lastDoc: lastDoc,
      hasReachedMax: hasReachedMax,
    );
  }

  Future<PaginatedModelResponse<ProductModel>> getProductsByCategory({
    required String category,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _firestore.collection('products')
        .where('category', isEqualTo: category)
        .orderBy(FieldPath.documentId)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();
    final items = querySnapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();

    final hasReachedMax = items.length < limit;
    final lastDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    return PaginatedModelResponse(
      items: items,
      lastDoc: lastDoc,
      hasReachedMax: hasReachedMax,
    );
  }

  Future<ProductModel> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (!doc.exists) throw Exception('Product not found');
    return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    
    
    final snapshot = await _firestore.collection('products').get();
    final q = query.toLowerCase();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    final docRef = product.id.isEmpty
        ? _firestore.collection('products').doc()
        : _firestore.collection('products').doc(product.id);
    await docRef.set({
      'id': docRef.id,
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'originalPrice': product.originalPrice,
      'offerPercentage': product.offerPercentage,
      'rating': product.rating,
      'reviewsCount': product.reviewsCount,
      'category': product.category,
      'sku': product.sku,
      'barcode': product.barcode,
      'stock': product.stock,
      'isActive': product.isActive,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'originalPrice': product.originalPrice,
      'offerPercentage': product.offerPercentage,
      'rating': product.rating,
      'reviewsCount': product.reviewsCount,
      'category': product.category,
      'sku': product.sku,
      'barcode': product.barcode,
      'stock': product.stock,
      'isActive': product.isActive,
    });
  }

  Future<void> toggleProductActive(String id, bool isActive) async {
    await _firestore
        .collection('products')
        .doc(id)
        .update({'isActive': isActive});
  }

  Future<void> deleteProduct(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (doc.exists) {
        final data = doc.data();
        final String? imageUrl = data?['imageUrl'] as String?;
        if (imageUrl != null && imageUrl.contains('firebasestorage.googleapis.com')) {
          try {
            final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
            await storageRef.delete();
          } catch (e) {
            
          }
        }
      }
    } catch (_) {}
    await _firestore.collection('products').doc(id).delete();
  }
}
