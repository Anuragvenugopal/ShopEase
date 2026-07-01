import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String name;
  final double rating;
  final String text;

  const ReviewModel({
    required this.name,
    required this.rating,
    required this.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewEntity toEntity() => ReviewEntity(
        name: name,
        rating: rating,
        text: text,
      );

  factory ReviewModel.fromEntity(ReviewEntity entity) => ReviewModel(
        name: entity.name,
        rating: entity.rating,
        text: entity.text,
      );
}

@JsonSerializable()
class ProductModel {
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
  final List<ReviewModel> reviews;

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        rating: rating,
        reviewsCount: reviewsCount,
        category: category,
        sku: sku,
        barcode: barcode,
        stock: stock,
        reviews: reviews.map((r) => r.toEntity()).toList(),
      );

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        imageUrl: entity.imageUrl,
        price: entity.price,
        originalPrice: entity.originalPrice,
        rating: entity.rating,
        reviewsCount: entity.reviewsCount,
        category: entity.category,
        sku: entity.sku,
        barcode: entity.barcode,
        stock: entity.stock,
        reviews: entity.reviews.map((r) => ReviewModel.fromEntity(r)).toList(),
      );
}
