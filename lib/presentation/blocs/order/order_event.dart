import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  final String userId;
  const LoadOrders(this.userId);
  @override
  List<Object?> get props => [userId];
}

class PlaceOrder extends OrderEvent {
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String shippingAddress;

  const PlaceOrder({
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [userId, items, totalAmount, shippingAddress];
}
