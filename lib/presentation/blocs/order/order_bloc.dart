import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../../domain/repositories/cart_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;

  OrderBloc(this._orderRepository, this._cartRepository)
      : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onLoadOrders(
      LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrders(event.userId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderRepository.placeOrder(
        userId: event.userId,
        items: event.items,
        totalAmount: event.totalAmount,
        shippingAddress: event.shippingAddress,
      );
      
      await _cartRepository.clearCart(event.userId);
      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
