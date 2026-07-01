import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/cart_item_model.dart';

@injectable
class CartRemoteDataSource {
  final FirebaseFirestore _firestore;

  CartRemoteDataSource(this._firestore);

  CollectionReference _cartRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('cart');

  Future<List<CartItemModel>> getCartItems(String userId) async {
    final snapshot = await _cartRef(userId).get();
    return snapshot.docs.map((doc) {
      return CartItemModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'productId': doc.id,
      });
    }).toList();
  }

  Future<void> addOrUpdateItem(String userId, CartItemModel item) async {
    await _cartRef(userId).doc(item.productId).set(item.toJson());
  }

  Future<void> updateQuantity(
      String userId, String productId, int quantity) async {
    await _cartRef(userId).doc(productId).update({'quantity': quantity});
  }

  Future<void> removeItem(String userId, String productId) async {
    await _cartRef(userId).doc(productId).delete();
  }

  Future<void> clearCart(String userId) async {
    final snapshot = await _cartRef(userId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
