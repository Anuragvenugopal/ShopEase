import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../data/datasources/admin_stats_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/blocs/admin_stats/admin_stats_bloc.dart';
import '../../presentation/blocs/admin_stats/admin_stats_event.dart';
import '../../presentation/blocs/admin_stats/admin_stats_state.dart';
import './widgets/dashboard_stat_card.dart';
import './widgets/control_tile.dart';
import './widgets/utility_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _ensureAdminAuth(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email != 'admin@shopease.com') {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'admin@shopease.com',
          password: 'Admin@123',
        );
        if (context.mounted) {
          context.read<AdminStatsBloc>().add(FetchAdminStats());
        }
      } catch (e) {
        final errorStr = e.toString();
        if (errorStr.contains('user-not-found') ||
            errorStr.contains('INVALID_LOGIN_CREDENTIALS') ||
            errorStr.contains('invalid-credential')) {
          try {
            final cred = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: 'admin@shopease.com',
                  password: 'Admin@123',
                );
            await FirebaseFirestore.instance
                .collection('users')
                .doc(cred.user!.uid)
                .set({
                  'id': cred.user!.uid,
                  'email': 'admin@shopease.com',
                  'displayName': 'Admin ShopEase',
                  'createdAt': FieldValue.serverTimestamp(),
                });
            if (context.mounted) {
              context.read<AdminStatsBloc>().add(FetchAdminStats());
            }
          } catch (_) {}
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureAdminAuth(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Operations'),
        actions: [
          
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Stats',
            onPressed: () {
              context.read<AdminStatsBloc>().add(FetchAdminStats());
            },
          ),
          
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Exit Admin Panel',
            onPressed: () {
              ConfirmationDialog.show(
                context,
                title: 'Exit Admin Panel',
                content:
                    'Are you sure you want to exit the admin console and switch back to the customer storefront?',
                confirmText: 'Exit Console',
                cancelText: 'Cancel',
                isDangerous: true,
                onConfirm: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isAdminLoggedIn', false);
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
              );
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
              
              BlocBuilder<AdminStatsBloc, AdminStatsState>(
                builder: (context, state) {
                  if (state is AdminStatsLoading ||
                      state is AdminStatsInitial) {
                    return _buildStatsShimmer(theme);
                  }

                  if (state is AdminStatsError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withOpacity(
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Failed to load stats. Tap refresh to retry.',
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded),
                            onPressed: () {
                              context.read<AdminStatsBloc>().add(
                                FetchAdminStats(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AdminStatsLoaded) {
                    final stats = state.stats;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        DashboardStatCard(
                          title: 'Total Products',
                          value: '${stats.totalProducts}',
                          icon: Icons.inventory_2_outlined,
                          color: theme.colorScheme.primary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.adminProductList),
                        ),
                        DashboardStatCard(
                          title: 'Registered Users',
                          value: '${stats.totalUsers}',
                          icon: Icons.people_alt_outlined,
                          color: Colors.teal,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers),
                        ),
                        DashboardStatCard(
                          title: 'Pending Orders',
                          value: '${stats.newOrders}',
                          icon: Icons.shopping_cart_checkout_rounded,
                          color: Colors.orange,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.adminOrders),
                        ),
                        DashboardStatCard(
                          title: 'Low Stock Alerts',
                          value: stats.lowStockCount == 0
                              ? 'None'
                              : '${stats.lowStockCount} Items',
                          icon: Icons.warning_amber_rounded,
                          color: stats.lowStockCount > 0
                              ? theme.colorScheme.error
                              : Colors.green,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.adminLowStock),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),

              
              Text(
                'Operations Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ControlTile(
                icon: Icons.list_alt_rounded,
                title: 'Product Catalog List',
                subtitle: 'Manage names, descriptions, images, prices',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.adminProductList),
              ),
              ControlTile(
                icon: Icons.add_circle_outline_rounded,
                title: 'Add New Product',
                subtitle: 'Enter SKUs, barcodes, base stocks, tags',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.adminAddProduct),
              ),

              ControlTile(
                icon: Icons.receipt_long_rounded,
                title: 'Customer Order Logs',
                subtitle: 'Modify order processing, packing, delivery states',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.adminOrders),
              ),
              ControlTile(
                icon: Icons.filter_list_rounded,
                title: 'Category Products Filter',
                subtitle: 'Browse and manage products filtered by category',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.adminProductList),
              ),

              const SizedBox(height: 24),
              Text(
                'Inventory Utilities',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: UtilityCard(
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'Barcode Scanner',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.adminBarcodeScanner,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: UtilityCard(
                      icon: Icons.find_in_page_rounded,
                      title: 'SKU Code Lookup',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.adminSkuSearch,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              
              CustomButton(
                text: 'Exit Admin Portal',
                isOutlined: true,
                onPressed: () {
                  ConfirmationDialog.show(
                    context,
                    title: 'Exit Admin Panel',
                    content:
                        'Are you sure you want to exit the admin console and switch back to the customer storefront?',
                    confirmText: 'Exit Console',
                    cancelText: 'Cancel',
                    isDangerous: true,
                    onConfirm: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isAdminLoggedIn', false);
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildStatsShimmer(ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: List.generate(4, (_) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }),
    );
  }
}
