import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  final String userId;
  const LoadWishlist(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ToggleWishlist extends WishlistEvent {
  final String userId;
  final String productId;
  final bool isCurrentlyWishlisted;
  const ToggleWishlist(this.userId, this.productId, this.isCurrentlyWishlisted);
  @override
  List<Object?> get props => [userId, productId, isCurrentlyWishlisted];
}

class CheckWishlistStatus extends WishlistEvent {
  final String userId;
  final String productId;
  const CheckWishlistStatus(this.userId, this.productId);
  @override
  List<Object?> get props => [userId, productId];
}
