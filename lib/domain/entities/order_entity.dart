import 'package:equatable/equatable.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderItemEntity extends Equatable {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, title, imageUrl, price, quantity];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String? shippingAddress;
  final String? trackingNumber;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.shippingAddress,
    this.trackingNumber,
  });

  @override
  List<Object?> get props =>
      [id, userId, items, totalAmount, status, createdAt, shippingAddress, trackingNumber];
}
