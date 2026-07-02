import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String name;
  final double rating;
  final String text;

  const ReviewEntity({
    required this.name,
    required this.rating,
    required this.text,
  });

  @override
  List<Object?> get props => [name, rating, text];
}

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int? offerPercentage; // read directly from Firebase
  final double rating;
  final int reviewsCount;
  final String category;
  final String subcategory;
  final String sku;
  final String barcode;
  final int stock;
  final List<ReviewEntity> reviews;
  final bool isActive; // enable/disable without deleting

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.offerPercentage,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    this.subcategory = '',
    required this.sku,
    required this.barcode,
    required this.stock,
    this.reviews = const [],
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    price,
    originalPrice,
    offerPercentage,
    rating,
    reviewsCount,
    category,
    subcategory,
    sku,
    barcode,
    stock,
    reviews,
    isActive,
  ];
}

class PaginatedProducts extends Equatable {
  final List<ProductEntity> products;
  final dynamic lastDoc;
  final bool hasReachedMax;

  const PaginatedProducts({
    required this.products,
    this.lastDoc,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [products, lastDoc, hasReachedMax];
}
