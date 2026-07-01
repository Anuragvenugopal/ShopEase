import 'package:flutter/material.dart';
import '../../main.dart'; // to access themeNotifier
import '../routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
              ),
            ),
            accountName: Text(
              'Jessica Doe',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            accountEmail: Text(
              'jessica.doe@example.com',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ),

          // Drawer Body Scrollable Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  route: AppRoutes.home,
                  isReplacement: true,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'Categories',
                  route: AppRoutes.categories,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Cart',
                  route: AppRoutes.cart,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.favorite_outline_rounded,
                  title: 'Wishlist',
                  route: AppRoutes.wishlist,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: 'Order History',
                  route: AppRoutes.orderHistory,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  route: AppRoutes.profile,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  route: AppRoutes.settingsRoute,
                ),
                const Divider(height: 32, indent: 8, endIndent: 8),

                // Theme Mode Switcher Inside Drawer
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    final currentIsDark = mode == ThemeMode.dark;
                    return SwitchListTile.adaptive(
                      title: Text(
                        currentIsDark ? 'Dark Mode' : 'Light Mode',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      secondary: Icon(
                        currentIsDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      value: currentIsDark,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Drawer Footer Section
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Button to Admin Dashboard
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close Drawer
                      Navigator.pushNamed(context, AppRoutes.adminLogin);
                    },
                    icon: const Icon(Icons.admin_panel_settings_outlined, size: 20),
                    label: const Text('Admin Portal'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Log Out Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close Drawer
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text('Log Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary.withOpacity(0.1),
                      foregroundColor: theme.colorScheme.tertiary,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    bool isReplacement = false,
  }) {
    final theme = Theme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onBackground.withOpacity(0.6),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onBackground,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.pop(context); // Close Drawer
          if (isSelected) return;
          if (isReplacement) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
