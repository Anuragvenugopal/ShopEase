import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<ProductEntity> items;
  final Set<String> wishlistedIds;

  const WishlistLoaded({required this.items, required this.wishlistedIds});

  bool isWishlisted(String productId) => wishlistedIds.contains(productId);

  @override
  List<Object?> get props => [items, wishlistedIds];
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);
  @override
  List<Object?> get props => [message];
}
