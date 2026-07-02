import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final dynamic lastDoc;

  const ProductsLoaded(
    this.products, {
    this.hasReachedMax = false,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [products, hasReachedMax, lastDoc];
}

class ProductDetailLoaded extends ProductState {
  final ProductEntity product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object?> get props => [message];
}
