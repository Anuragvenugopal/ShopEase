import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItemModel({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toEntity() => CartItemEntity(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
      );

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
        productId: entity.productId,
        title: entity.title,
        imageUrl: entity.imageUrl,
        price: entity.price,
        quantity: entity.quantity,
      );
}
