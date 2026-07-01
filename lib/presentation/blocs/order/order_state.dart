import 'package:equatable/equatable.dart';
import '../../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  const OrdersLoaded(this.orders);

  List<OrderEntity> get activeOrders => orders
      .where((o) =>
          o.status == OrderStatus.pending ||
          o.status == OrderStatus.confirmed ||
          o.status == OrderStatus.shipped)
      .toList();

  List<OrderEntity> get pastOrders => orders
      .where((o) =>
          o.status == OrderStatus.delivered ||
          o.status == OrderStatus.cancelled)
      .toList();

  @override
  List<Object?> get props => [orders];
}

class OrderPlaced extends OrderState {
  final OrderEntity order;
  const OrderPlaced(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}
