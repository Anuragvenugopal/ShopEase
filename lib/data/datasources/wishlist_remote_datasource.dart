import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class WishlistRemoteDataSource {
  final FirebaseFirestore _firestore;

  WishlistRemoteDataSource(this._firestore);

  DocumentReference _wishlistRef(String userId) =>
      _firestore.collection('users').doc(userId);

  Future<List<String>> getWishlistIds(String userId) async {
    final doc = await _wishlistRef(userId).get();
    if (!doc.exists) return [];
    final data = doc.data() as Map<String, dynamic>?;
    final wishlist = data?['wishlist'];
    if (wishlist is List) {
      return List<String>.from(wishlist);
    }
    return [];
  }

  Future<void> addToWishlist(String userId, String productId) async {
    await _wishlistRef(userId).set({
      'wishlist': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _wishlistRef(userId).set({
      'wishlist': FieldValue.arrayRemove([productId]),
    }, SetOptions(merge: true));
  }
}
