import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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
                  _buildDashboardStatCard(
                    title: 'Total Products',
                    value: '184',
                    icon: Icons.inventory_2_outlined,
                    color: theme.colorScheme.primary,
                    isDark: isDark,
                  ),
                  _buildDashboardStatCard(
                    title: 'Active Users',
                    value: '1,248',
                    icon: Icons.people_alt_outlined,
                    color: Colors.teal,
                    isDark: isDark,
                  ),
                  _buildDashboardStatCard(
                    title: 'New Orders',
                    value: '42',
                    icon: Icons.shopping_cart_checkout_rounded,
                    color: Colors.orange,
                    isDark: isDark,
                  ),
                  _buildDashboardStatCard(
                    title: 'Low Stock Alerts',
                    value: '3 Items',
                    icon: Icons.warning_amber_rounded,
                    color: theme.colorScheme.tertiary,
                    isDark: isDark,
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

              _buildControlTile(
                icon: Icons.list_alt_rounded,
                title: 'Product Catalog List',
                subtitle: 'Manage names, descriptions, images, prices',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminProductList),
                theme: theme,
              ),
              _buildControlTile(
                icon: Icons.add_circle_outline_rounded,
                title: 'Add New Product',
                subtitle: 'Enter SKUs, barcodes, base stocks, tags',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
                theme: theme,
              ),
              _buildControlTile(
                icon: Icons.category_outlined,
                title: 'Category & Subcategory Manager',
                subtitle: 'Organize category nodes and tags',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminCategories),
                theme: theme,
              ),
              _buildControlTile(
                icon: Icons.receipt_long_rounded,
                title: 'Customer Order Logs',
                subtitle: 'Modify order processing, packing, delivery states',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminOrders),
                theme: theme,
              ),
              _buildControlTile(
                icon: Icons.warning_rounded,
                title: 'Stock Replenishments',
                subtitle: 'View items under low threshold limits',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminLowStock),
                theme: theme,
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
                    child: _buildUtilityCard(
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'Barcode Scanner',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminBarcodeScanner),
                      theme: theme,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUtilityCard(
                      icon: Icons.find_in_page_rounded,
                      title: 'SKU Code Lookup',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminSkuSearch),
                      theme: theme,
                      isDark: isDark,
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

  Widget _buildDashboardStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildControlTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    int badgeCount = 0,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUtilityCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
