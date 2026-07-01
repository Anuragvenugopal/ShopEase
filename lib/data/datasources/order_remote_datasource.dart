import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/order_model.dart';
import '../../domain/entities/cart_item_entity.dart';

@injectable
class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource(this._firestore);

  Future<List<OrderModel>> getOrders(String userId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return OrderModel.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  Future<OrderModel> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String shippingAddress,
  }) async {
    final orderData = {
      'userId': userId,
      'items': items
          .map((i) => {
                'productId': i.productId,
                'title': i.title,
                'imageUrl': i.imageUrl,
                'price': i.price,
                'quantity': i.quantity,
              })
          .toList(),
      'totalAmount': totalAmount,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'shippingAddress': shippingAddress,
      'trackingNumber': null,
    };

    final docRef = await _firestore.collection('orders').add(orderData);
    final doc = await docRef.get();
    return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) throw Exception('Order not found');
    return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
  }
}
