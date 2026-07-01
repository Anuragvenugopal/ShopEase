import '../entities/product_entity.dart';

abstract class WishlistRepository {
  Future<List<ProductEntity>> getWishlistItems(String userId);
  Future<void> addToWishlist(String userId, String productId);
  Future<void> removeFromWishlist(String userId, String productId);
  Future<bool> isWishlisted(String userId, String productId);
}
