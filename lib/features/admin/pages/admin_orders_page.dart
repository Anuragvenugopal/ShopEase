import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  // Mock Order list data
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'SE-39841-02',
      'customer': 'Jessica Doe',
      'date': 'Jul 01, 2026',
      'amount': 199.99,
      'status': 'Shipped',
      'items': 'Wireless Headphones (x1)',
    },
    {
      'id': 'SE-21942-88',
      'customer': 'Alex Johnson',
      'date': 'Jun 29, 2026',
      'amount': 89.00,
      'status': 'Processing',
      'items': 'Smart Sports Watch (x1)',
    },
    {
      'id': 'SE-10294-11',
      'customer': 'Sarah Jenkins',
      'date': 'May 12, 2026',
      'amount': 34.00,
      'status': 'Delivered',
      'items': 'Matte Ceramic Vase (x1)',
    },
    {
      'id': 'SE-09412-42',
      'customer': 'Michael Miller',
      'date': 'Apr 02, 2026',
      'amount': 129.50,
      'status': 'Cancelled',
      'items': 'Premium Leather Jacket (x1)',
    },
  ];

  final List<String> _statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _orders[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${_orders[index]['id']} status updated to "$newStatus"'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        return theme.colorScheme.tertiary; // Cancelled
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            final statusColor = _getStatusColor(order['status'], theme);

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
                      Text(
                        order['id']!,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order['status']!,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Customer Details and Info
                  _buildOrderInfoRow('Customer', order['customer']!, theme),
                  const SizedBox(height: 6),
                  _buildOrderInfoRow('Placed On', order['date']!, theme),
                  const SizedBox(height: 6),
                  _buildOrderInfoRow('Purchased Items', order['items']!, theme),
                  const SizedBox(height: 6),
                  _buildOrderInfoRow(
                    'Order Value Sum',
                    '\$${order['amount'].toStringAsFixed(2)}',
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
                        value: _statuses.contains(order['status']) ? order['status'] : 'Pending',
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        items: _statuses.map((stat) {
                          return DropdownMenuItem(value: stat, child: Text(stat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) _updateStatus(index, val);
                        },
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
