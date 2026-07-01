import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final String category;
  const LoadProductsByCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class LoadProductById extends ProductEvent {
  final String productId;
  const LoadProductById(this.productId);
  @override
  List<Object?> get props => [productId];
}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object?> get props => [query];
}

class AddProduct extends ProductEvent {
  final ProductEntity product;
  const AddProduct(this.product);
  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final ProductEntity product;
  const UpdateProduct(this.product);
  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String id;
  const DeleteProduct(this.id);
  @override
  List<Object?> get props => [id];
}
