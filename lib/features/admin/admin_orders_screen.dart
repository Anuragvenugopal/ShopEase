import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/widgets/custom_app_bar.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const List<String> _statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];

  Future<void> _updateStatus(BuildContext context, String docId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(docId).update({
        'status': newStatus,
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to "$newStatus"'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return theme.colorScheme.primary;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return theme.colorScheme.tertiary; // cancelled
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Customer Order Logs',
        showBackButton: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('orders').orderBy('createdAt', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No customer orders found.', style: theme.textTheme.bodyMedium),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final docId = doc.id;
                final status = data['status'] ?? 'pending';
                final amount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
                final address = data['shippingAddress'] ?? 'No Address';
                
                // Parse items to summary string
                final itemsList = data['items'] as List<dynamic>? ?? [];
                final itemsSummary = itemsList.map((item) {
                  final title = item['title'] ?? 'Product';
                  final qty = item['quantity'] ?? 1;
                  return '$title (x$qty)';
                }).join(', ');

                // Parse createdAt timestamp
                String dateStr = 'Unknown date';
                if (data['createdAt'] != null) {
                  final timestamp = data['createdAt'] as Timestamp;
                  final dt = timestamp.toDate();
                  dateStr = '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
                }

                final statusColor = _getStatusColor(status, theme);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Order Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'ID: $docId',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.toString().toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Customer details
                      _buildOrderInfoRow('Placed On', dateStr, theme),
                      const SizedBox(height: 6),
                      _buildOrderInfoRow('Shipping Address', address, theme),
                      const SizedBox(height: 6),
                      _buildOrderInfoRow('Purchased Items', itemsSummary.isEmpty ? 'No Items' : itemsSummary, theme),
                      const SizedBox(height: 6),
                      _buildOrderInfoRow(
                        'Total Value',
                        '₹${amount.toStringAsFixed(0)}',
                        theme,
                        isAccent: true,
                      ),

                      const Divider(height: 24),

                      // Action Status Controller Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Change Order Status:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: _statuses.contains(status) ? status : 'pending',
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            items: _statuses.map((stat) {
                              return DropdownMenuItem(value: stat, child: Text(stat.toUpperCase()));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) _updateStatus(context, docId, val);
                            },
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value, ThemeData theme, {bool isAccent = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isAccent ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}