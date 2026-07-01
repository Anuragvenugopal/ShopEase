import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/dummy_data.dart';
import '../models/product_model.dart';

@injectable
class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource(this._firestore);

  Future<List<ProductModel>> getProducts() async {
    // Seed categories if not yet created
    final catSnapshot = await _firestore.collection('categories').get();
    if (catSnapshot.docs.isEmpty) {
      for (final cat in DummyData.categories) {
        final docRef = _firestore.collection('categories').doc();
        await docRef.set({
          'id': docRef.id,
          'name': cat.title,
          'imageUrl': cat.imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }

    // Fetch existing SKUs to avoid duplicates
    var snapshot = await _firestore.collection('products').get();
    final existingSkus = snapshot.docs
        .map((d) => d.data()['sku'] as String? ?? '')
        .toSet();

    // Seed any missing products from DummyData
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

    // Re-fetch if we added new products
    if (seeded) {
      snapshot = await _firestore.collection('products').get();
    }

    return snapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }


  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (!doc.exists) throw Exception('Product not found');
    return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    // Firestore doesn't support full-text search natively.
    // Fetch all and filter client-side (or use Algolia/Typesense for production).
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
      'rating': product.rating,
      'reviewsCount': product.reviewsCount,
      'category': product.category,
      'sku': product.sku,
      'barcode': product.barcode,
      'stock': product.stock,
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
      'rating': product.rating,
      'reviewsCount': product.reviewsCount,
      'category': product.category,
      'sku': product.sku,
      'barcode': product.barcode,
      'stock': product.stock,
    });
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}
