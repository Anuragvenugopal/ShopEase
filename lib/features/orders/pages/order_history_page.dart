import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Orders',
        showBackButton: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          tabs: const [
            Tab(text: 'Active Tracking'),
            Tab(text: 'Past Purchases'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active tracking list
          _buildActiveTrackingView(isDark, theme),

          // Past purchases list
          _buildPastPurchasesView(isDark, theme),
        ],
      ),
    );
  }

  Widget _buildActiveTrackingView(bool isDark, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          orderId: 'SE-39841-02',
          date: 'July 01, 2026',
          price: 199.99,
          status: 'Shipped',
          statusStep: 2, // 0 = Ordered, 1 = Processing, 2 = Shipped, 3 = Delivered
          product: DummyData.products[0], // Noise-Cancelling Headphones
          isDark: isDark,
          theme: theme,
          canCancel: true,
        ),
        _buildOrderCard(
          orderId: 'SE-21942-88',
          date: 'June 29, 2026',
          price: 89.00,
          status: 'In Processing',
          statusStep: 1,
          product: DummyData.products[3], // Smart Sports Watch
          isDark: isDark,
          theme: theme,
          canCancel: true,
        ),
      ],
    );
  }

  Widget _buildPastPurchasesView(bool isDark, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          orderId: 'SE-10294-11',
          date: 'May 12, 2026',
          price: 34.00,
          status: 'Delivered',
          statusStep: 3,
          product: DummyData.products[2], // Matte Vase
          isDark: isDark,
          theme: theme,
          canCancel: false,
        ),
        _buildOrderCard(
          orderId: 'SE-09412-42',
          date: 'April 02, 2026',
          price: 129.50,
          status: 'Delivered',
          statusStep: 3,
          product: DummyData.products[1], // Leather Jacket
          isDark: isDark,
          theme: theme,
          canCancel: false,
        ),
      ],
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required double price,
    required String status,
    required int statusStep,
    required DummyProduct product,
    required bool isDark,
    required ThemeData theme,
    required bool canCancel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderId,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text('Placed on $date', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                ],
              ),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Order Item thumbnail + title
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                    child: const Icon(Icons.broken_image_outlined, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  product.title,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal Status Tracker Stepper
          Text('Tracking Status: $status', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          _buildStatusProgress(statusStep, theme),
          const SizedBox(height: 20),

          // Cancel or Write Review action buttons
          Row(
            children: [
              if (canCancel)
                Expanded(
                  child: CustomButton(
                    text: 'Cancel Order',
                    isOutlined: true,
                    height: 44,
                    onPressed: () {
                      ConfirmationDialog.show(
                        context,
                        title: 'Cancel Order',
                        content: 'Are you sure you want to cancel this order? This action cannot be undone.',
                        confirmText: 'Yes, Cancel',
                        isDangerous: true,
                        onConfirm: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order cancellation request sent successfully.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              else ...[
                Expanded(
                  child: CustomButton(
                    text: 'Buy Again',
                    height: 44,
                    onPressed: () {
                      DummyData.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to Cart!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Write Review',
                    isOutlined: true,
                    height: 44,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review platform mock dialog opened.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusProgress(int currentStep, ThemeData theme) {
    final List<String> steps = ['Ordered', 'Process', 'Shipped', 'Delivered'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;
        
        return Expanded(
          child: Row(
            children: [
              // Step Dot
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isCompleted ? theme.colorScheme.secondary : theme.dividerColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              
              // Connecting Line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 3,
                    color: index < currentStep ? theme.colorScheme.secondary : theme.dividerColor,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
