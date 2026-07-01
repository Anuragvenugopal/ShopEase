import '../entities/order_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders(String userId);
  Future<OrderEntity> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String shippingAddress,
  });
  Future<OrderEntity> getOrderById(String orderId);
}
