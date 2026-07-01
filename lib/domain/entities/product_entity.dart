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
  final double rating;
  final int reviewsCount;
  final String category;
  final String sku;
  final String barcode;
  final int stock;
  final List<ReviewEntity> reviews;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.sku,
    required this.barcode,
    required this.stock,
    this.reviews = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        price,
        originalPrice,
        rating,
        reviewsCount,
        category,
        sku,
        barcode,
        stock,
        reviews,
      ];
}
