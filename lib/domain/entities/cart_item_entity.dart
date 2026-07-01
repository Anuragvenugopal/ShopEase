import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      productId: productId,
      title: title,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, title, imageUrl, price, quantity];
}
