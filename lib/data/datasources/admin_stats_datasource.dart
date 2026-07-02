import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';


class AdminDashboardStats {
  final int totalProducts;
  final int totalUsers;
  final int newOrders;       
  final int lowStockCount;   

  const AdminDashboardStats({
    required this.totalProducts,
    required this.totalUsers,
    required this.newOrders,
    required this.lowStockCount,
  });
}

@injectable
class AdminStatsDataSource {
  final FirebaseFirestore _firestore;

  
  static const int lowStockThreshold = 5;

  AdminStatsDataSource(this._firestore);

  Future<AdminDashboardStats> fetchStats() async {
    final results = await Future.wait([
      _firestore.collection('products').get(),
      _firestore.collection('users').get(),
      _firestore.collection('orders').where('status', isEqualTo: 'pending').get(),
    ]);

    final productsSnap = results[0];
    final usersSnap = results[1];
    final ordersSnap = results[2];

    final lowStock = productsSnap.docs.where((doc) {
      final stock = (doc.data()['stock'] as num?)?.toInt() ?? 0;
      return stock <= lowStockThreshold;
    }).length;

    return AdminDashboardStats(
      totalProducts: productsSnap.docs.length,
      totalUsers: usersSnap.docs.length,
      newOrders: ordersSnap.docs.length,
      lowStockCount: lowStock,
    );
  }
}
