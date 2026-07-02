// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  name: json['name'] as String,
  rating: (json['rating'] as num).toDouble(),
  text: json['text'] as String,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rating': instance.rating,
      'text': instance.text,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  offerPercentage: (json['offerPercentage'] as num?)?.toInt(),
  rating: (json['rating'] as num).toDouble(),
  reviewsCount: (json['reviewsCount'] as num).toInt(),
  category: json['category'] as String,
  subcategory: json['subcategory'] as String? ?? '',
  sku: json['sku'] as String,
  barcode: json['barcode'] as String,
  stock: (json['stock'] as num).toInt(),
  reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'offerPercentage': instance.offerPercentage,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'stock': instance.stock,
      'reviews': instance.reviews,
      'isActive': instance.isActive,
    };
