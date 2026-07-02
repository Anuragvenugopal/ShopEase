import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartQuantity>(_onUpdateQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  
  
  
  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    final currentItems =
        currentState is CartLoaded ? List<CartItemEntity>.from(currentState.items) : <CartItemEntity>[];

    
    final idx = currentItems.indexWhere((i) => i.productId == event.item.productId);
    final CartItemEntity resolvedItem;
    List<CartItemEntity> optimisticItems;

    if (idx != -1) {
      
      resolvedItem = currentItems[idx].copyWith(
        quantity: currentItems[idx].quantity + event.item.quantity,
      );
      optimisticItems = List.from(currentItems);
      optimisticItems[idx] = resolvedItem;
    } else {
      
      resolvedItem = event.item;
      optimisticItems = [...currentItems, event.item];
    }

    
    emit(CartLoaded(optimisticItems));

    
    try {
      await _cartRepository.addToCart(event.userId, resolvedItem);
    } catch (e) {
      
      emit(CartLoaded(currentItems));
    }
  }

  
  Future<void> _onUpdateQuantity(
      UpdateCartQuantity event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItems = List<CartItemEntity>.from(currentState.items);

    
    List<CartItemEntity> optimisticItems;
    if (event.quantity <= 0) {
      optimisticItems = currentItems.where((i) => i.productId != event.productId).toList();
    } else {
      optimisticItems = currentItems.map((i) {
        return i.productId == event.productId ? i.copyWith(quantity: event.quantity) : i;
      }).toList();
    }

    
    emit(CartLoaded(optimisticItems));

    
    try {
      await _cartRepository.updateQuantity(event.userId, event.productId, event.quantity);
    } catch (e) {
      
      emit(CartLoaded(currentItems));
    }
  }

  
  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItems = List<CartItemEntity>.from(currentState.items);

    
    final optimisticItems =
        currentItems.where((i) => i.productId != event.productId).toList();

    
    emit(CartLoaded(optimisticItems));

    
    try {
      await _cartRepository.removeFromCart(event.userId, event.productId);
    } catch (e) {
      
      emit(CartLoaded(currentItems));
    }
  }

  
  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final currentItems =
        state is CartLoaded ? List<CartItemEntity>.from((state as CartLoaded).items) : <CartItemEntity>[];

    
    emit(const CartLoaded([]));

    try {
      await _cartRepository.clearCart(event.userId);
    } catch (e) {
      
      emit(CartLoaded(currentItems));
    }
  }
}
