import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;

  const CartLoaded(this.items);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal > 150
      ? 0.0
      : subtotal == 0
          ? 0.0
          : 15.0;

  double get total => subtotal + shipping;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

class CartOperationSuccess extends CartState {
  final String message;
  const CartOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
