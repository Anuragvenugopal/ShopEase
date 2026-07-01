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

  // ─── Load (only network call that waits) ────────────────────────────────────
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ─── Add to Cart — optimistic update ─────────────────────────────────────────
  // 1. Immediately update in-memory state (UI reacts instantly)
  // 2. Persist to Firestore in background (no extra read)
  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    final currentItems =
        currentState is CartLoaded ? List<CartItemEntity>.from(currentState.items) : <CartItemEntity>[];

    // Compute merged item and new list locally
    final idx = currentItems.indexWhere((i) => i.productId == event.item.productId);
    final CartItemEntity resolvedItem;
    List<CartItemEntity> optimisticItems;

    if (idx != -1) {
      // Already in cart — increment quantity
      resolvedItem = currentItems[idx].copyWith(
        quantity: currentItems[idx].quantity + event.item.quantity,
      );
      optimisticItems = List.from(currentItems);
      optimisticItems[idx] = resolvedItem;
    } else {
      // New item
      resolvedItem = event.item;
      optimisticItems = [...currentItems, event.item];
    }

    // Emit instantly — UI updates with zero lag
    emit(CartLoaded(optimisticItems));

    // Persist resolved item (with correct merged qty) to Firestore in background
    try {
      await _cartRepository.addToCart(event.userId, resolvedItem);
    } catch (e) {
      // Rollback on failure
      emit(CartLoaded(currentItems));
    }
  }

  // ─── Update Quantity — optimistic update ─────────────────────────────────────
  Future<void> _onUpdateQuantity(
      UpdateCartQuantity event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItems = List<CartItemEntity>.from(currentState.items);

    // Optimistic: update or remove locally
    List<CartItemEntity> optimisticItems;
    if (event.quantity <= 0) {
      optimisticItems = currentItems.where((i) => i.productId != event.productId).toList();
    } else {
      optimisticItems = currentItems.map((i) {
        return i.productId == event.productId ? i.copyWith(quantity: event.quantity) : i;
      }).toList();
    }

    // Emit instantly
    emit(CartLoaded(optimisticItems));

    // Persist to Firestore in background
    try {
      await _cartRepository.updateQuantity(event.userId, event.productId, event.quantity);
    } catch (e) {
      // Rollback on failure
      emit(CartLoaded(currentItems));
    }
  }

  // ─── Remove from Cart — optimistic update ─────────────────────────────────────
  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItems = List<CartItemEntity>.from(currentState.items);

    // Optimistic: remove locally
    final optimisticItems =
        currentItems.where((i) => i.productId != event.productId).toList();

    // Emit instantly
    emit(CartLoaded(optimisticItems));

    // Persist to Firestore in background
    try {
      await _cartRepository.removeFromCart(event.userId, event.productId);
    } catch (e) {
      // Rollback on failure
      emit(CartLoaded(currentItems));
    }
  }

  // ─── Clear Cart ──────────────────────────────────────────────────────────────
  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final currentItems =
        state is CartLoaded ? List<CartItemEntity>.from((state as CartLoaded).items) : <CartItemEntity>[];

    // Optimistic: clear instantly
    emit(const CartLoaded([]));

    try {
      await _cartRepository.clearCart(event.userId);
    } catch (e) {
      // Rollback on failure
      emit(CartLoaded(currentItems));
    }
  }
}
