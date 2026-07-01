import 'package:injectable/injectable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _dataSource;

  CartRepositoryImpl(this._dataSource);

  @override
  Future<List<CartItemEntity>> getCartItems(String userId) async {
    final models = await _dataSource.getCartItems(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addToCart(String userId, CartItemEntity item) async {
    // BLoC handles the duplicate-check optimistically in memory.
    // We just persist the item directly; if it exists it gets overwritten
    // with the correct merged quantity from the BLoC's optimistic state.
    await _dataSource.addOrUpdateItem(userId, CartItemModel.fromEntity(item));
  }

  @override
  Future<void> updateQuantity(
      String userId, String productId, int quantity) async {
    if (quantity <= 0) {
      await _dataSource.removeItem(userId, productId);
    } else {
      await _dataSource.updateQuantity(userId, productId, quantity);
    }
  }

  @override
  Future<void> removeFromCart(String userId, String productId) async {
    await _dataSource.removeItem(userId, productId);
  }

  @override
  Future<void> clearCart(String userId) => _dataSource.clearCart(userId);
}
