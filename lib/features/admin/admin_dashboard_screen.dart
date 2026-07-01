import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import './widgets/dashboard_stat_card.dart';
import './widgets/control_tile.dart';
import './widgets/utility_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Operations'),
        actions: [
          // Switch to Customer Mode
          IconButton(
            icon: const Icon(Icons.storefront_rounded),
            tooltip: 'Customer Storefront',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dashboard Metrics Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  DashboardStatCard(
                    title: 'Total Products',
                    value: '184',
                    icon: Icons.inventory_2_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  DashboardStatCard(
                    title: 'Active Users',
                    value: '1,248',
                    icon: Icons.people_alt_outlined,
                    color: Colors.teal,
                  ),
                  DashboardStatCard(
                    title: 'New Orders',
                    value: '42',
                    icon: Icons.shopping_cart_checkout_rounded,
                    color: Colors.orange,
                  ),
                  DashboardStatCard(
                    title: 'Low Stock Alerts',
                    value: '3 Items',
                    icon: Icons.warning_amber_rounded,
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Operational Operations Sections
              Text(
                'Operations Management',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ControlTile(
                icon: Icons.list_alt_rounded,
                title: 'Product Catalog List',
                subtitle: 'Manage names, descriptions, images, prices',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminProductList),
              ),
              ControlTile(
                icon: Icons.add_circle_outline_rounded,
                title: 'Add New Product',
                subtitle: 'Enter SKUs, barcodes, base stocks, tags',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
              ),
              ControlTile(
                icon: Icons.category_outlined,
                title: 'Category & Subcategory Manager',
                subtitle: 'Organize category nodes and tags',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminCategories),
              ),
              ControlTile(
                icon: Icons.receipt_long_rounded,
                title: 'Customer Order Logs',
                subtitle: 'Modify order processing, packing, delivery states',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminOrders),
              ),
              ControlTile(
                icon: Icons.warning_rounded,
                title: 'Stock Replenishments',
                subtitle: 'View items under low threshold limits',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminLowStock),
                badgeCount: 3,
              ),

              const SizedBox(height: 24),
              Text(
                'Inventory Utilities',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: UtilityCard(
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'Barcode Scanner',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminBarcodeScanner),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: UtilityCard(
                      icon: Icons.find_in_page_rounded,
                      title: 'SKU Code Lookup',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminSkuSearch),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Return to login button
              CustomButton(
                text: 'Exit Admin Portal',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}