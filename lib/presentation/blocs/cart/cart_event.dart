import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  final String userId;
  const LoadCart(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddToCart extends CartEvent {
  final String userId;
  final CartItemEntity item;
  const AddToCart(this.userId, this.item);
  @override
  List<Object?> get props => [userId, item];
}

class UpdateCartQuantity extends CartEvent {
  final String userId;
  final String productId;
  final int quantity;
  const UpdateCartQuantity(this.userId, this.productId, this.quantity);
  @override
  List<Object?> get props => [userId, productId, quantity];
}

class RemoveFromCart extends CartEvent {
  final String userId;
  final String productId;
  const RemoveFromCart(this.userId, this.productId);
  @override
  List<Object?> get props => [userId, productId];
}

class ClearCart extends CartEvent {
  final String userId;
  const ClearCart(this.userId);
  @override
  List<Object?> get props => [userId];
}
