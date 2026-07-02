import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/wishlist_repository.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

@injectable
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc(this._wishlistRepository) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
    on<CheckWishlistStatus>(_onCheckStatus);
  }

  Future<void> _onLoadWishlist(
      LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepository.getWishlistItems(event.userId);
      final ids = items.map((p) => p.id).toSet();
      emit(WishlistLoaded(items: items, wishlistedIds: ids));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onToggleWishlist(
      ToggleWishlist event, Emitter<WishlistState> emit) async {
    try {
      if (event.isCurrentlyWishlisted) {
        await _wishlistRepository.removeFromWishlist(
            event.userId, event.productId);
      } else {
        await _wishlistRepository.addToWishlist(event.userId, event.productId);
      }
      
      final items = await _wishlistRepository.getWishlistItems(event.userId);
      final ids = items.map((p) => p.id).toSet();
      emit(WishlistLoaded(items: items, wishlistedIds: ids));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onCheckStatus(
      CheckWishlistStatus event, Emitter<WishlistState> emit) async {
    
    
  }
}
