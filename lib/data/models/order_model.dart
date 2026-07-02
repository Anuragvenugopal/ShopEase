import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_model.g.dart';


@JsonSerializable()
class OrderItemModel {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItemModel({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItemEntity toEntity() => OrderItemEntity(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
      );
}


class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String? shippingAddress;
  final String? trackingNumber;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.shippingAddress,
    this.trackingNumber,
  });

  
  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now(); 
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        status: json['status'] as String,
        createdAt: _parseDate(json['createdAt']),
        shippingAddress: json['shippingAddress'] as String?,
        trackingNumber: json['trackingNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((i) => i.toJson()).toList(),
        'totalAmount': totalAmount,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'shippingAddress': shippingAddress,
        'trackingNumber': trackingNumber,
      };

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        items: items.map((i) => i.toEntity()).toList(),
        totalAmount: totalAmount,
        status: _parseStatus(status),
        createdAt: createdAt,
        shippingAddress: shippingAddress,
        trackingNumber: trackingNumber,
      );

  static OrderStatus _parseStatus(String s) {
    switch (s) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
