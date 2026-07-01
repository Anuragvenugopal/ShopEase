import 'package:flutter/material.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/app_text.dart';
import './widgets/active_tracking_view.dart';
import './widgets/past_purchases_view.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
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
            Tab(child: AppText('Active Tracking', variant: AppTextVariant.labelLarge, bold: true)),
            Tab(child: AppText('Past Purchases', variant: AppTextVariant.labelLarge, bold: true)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ActiveTrackingView(),
          PastPurchasesView(),
        ],
      ),
    );
  }
}