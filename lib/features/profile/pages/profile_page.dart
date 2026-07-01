import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../authentication/pages/login_page.dart'; // fallback import
import '../../../main.dart'; // to access themeNotifier

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              // Avatar & Profile Info Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.primary, width: 2.5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                              ),
                            ),
                          ),
                        ),
                        
                        // Edit Avatar pencil button overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.editProfile);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Jessica Doe',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'jessica.doe@example.com',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // E-commerce Loyalty/Rewards Bento Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF311042)]
                        : [const Color(0xFFEEF2FF), const Color(0xFFFAE8FF)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRewardMetric('Reward Coins', '2,450', Icons.stars_rounded, theme),
                    Container(width: 1, height: 40, color: theme.dividerColor),
                    _buildRewardMetric('Coupons', '3 Active', Icons.confirmation_number_rounded, theme),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Menu navigation options
              Text(
                'Account Settings',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildMenuTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Personal Details',
                onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                theme: theme,
              ),
              _buildMenuTile(
                icon: Icons.receipt_long_outlined,
                title: 'Order Summary Log',
                onTap: () => Navigator.pushNamed(context, AppRoutes.orderHistory),
                theme: theme,
              ),
              _buildMenuTile(
                icon: Icons.pin_drop_outlined,
                title: 'Delivery Addresses',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address management mockup triggered')),
                  );
                },
                theme: theme,
              ),
              _buildMenuTile(
                icon: Icons.settings_outlined,
                title: 'App Settings',
                onTap: () => Navigator.pushNamed(context, AppRoutes.settingsRoute),
                theme: theme,
              ),

              const Divider(height: 32),

              // Dev portals & switchers
              Text(
                'Developer Tools',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // Toggle Light/Dark mode inline
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (_, currentMode, __) {
                  final isCurrentlyDark = currentMode == ThemeMode.dark;
                  return Card(
                    elevation: 0,
                    color: isDark ? const Color(0xFF161F30) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                      ),
                    ),
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Dark Theme Mode',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: const Text('Toggle app visualization', style: TextStyle(fontSize: 11)),
                      value: isCurrentlyDark,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              _buildMenuTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Switch to Admin Module',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminLogin),
                theme: theme,
                tileColor: theme.colorScheme.primary.withOpacity(0.08),
                iconColor: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),
              
              // Log Out action
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('Log Out Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary.withOpacity(0.12),
                  foregroundColor: theme.colorScheme.tertiary,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardMetric(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    Color? tileColor,
    Color? iconColor,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: tileColor ?? (isDark ? const Color(0xFF161F30) : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? theme.colorScheme.onBackground.withOpacity(0.7)),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
