import 'package:injectable/injectable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/wishlist_remote_datasource.dart';

@Injectable(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _dataSource;
  final ProductRepository _productRepository;

  WishlistRepositoryImpl(this._dataSource, this._productRepository);

  @override
  Future<List<ProductEntity>> getWishlistItems(String userId) async {
    final ids = await _dataSource.getWishlistIds(userId);
    if (ids.isEmpty) return [];
    
    final products = await Future.wait(
      ids.map((id) => _productRepository.getProductById(id)),
    );
    return products;
  }

  @override
  Future<void> addToWishlist(String userId, String productId) =>
      _dataSource.addToWishlist(userId, productId);

  @override
  Future<void> removeFromWishlist(String userId, String productId) =>
      _dataSource.removeFromWishlist(userId, productId);

  @override
  Future<bool> isWishlisted(String userId, String productId) async {
    final ids = await _dataSource.getWishlistIds(userId);
    return ids.contains(productId);
  }
}
