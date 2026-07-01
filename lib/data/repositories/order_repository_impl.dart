import 'package:injectable/injectable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

@Injectable(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _dataSource;

  OrderRepositoryImpl(this._dataSource);

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    final models = await _dataSource.getOrders(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<OrderEntity> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String shippingAddress,
  }) async {
    final model = await _dataSource.placeOrder(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
    );
    return model.toEntity();
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final model = await _dataSource.getOrderById(orderId);
    return model.toEntity();
  }
}
