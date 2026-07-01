import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNewsletter = false;
  bool _biometricLock = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'App Settings',
        showBackButton: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Notifications Category
            _buildSectionHeader('Notifications', theme),
            _buildSettingsCard(
              isDark,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Get alerts for deals and order arrivals', style: TextStyle(fontSize: 11)),
                    value: _pushNotifications,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _pushNotifications = val;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    title: const Text('Email Newsletters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Weekly custom digests, recommendations', style: TextStyle(fontSize: 11)),
                    value: _emailNewsletter,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _emailNewsletter = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security Category
            _buildSectionHeader('Security & Biometrics', theme),
            _buildSettingsCard(
              isDark,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('Enable FaceID / TouchID', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Fast biometrics verification on app open', style: TextStyle(fontSize: 11)),
                    value: _biometricLock,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _biometricLock = val;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Change Account Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Last changed 3 months ago', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password modification dialog template')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Regional Preferences
            _buildSectionHeader('Regional Preferences', theme),
            _buildSettingsCard(
              isDark,
              child: ListTile(
                leading: const Icon(Icons.language_rounded),
                title: const Text('App Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Spanish', child: Text('Spanish (ES)')),
                    DropdownMenuItem(value: 'French', child: Text('French (FR)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedLanguage = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Legal & About
            _buildSectionHeader('Support & Legal', theme),
            _buildSettingsCard(
              isDark,
              child: Column(
                children: [
                  _buildNavigationRow('Terms of Service', () {}, theme),
                  const Divider(height: 1),
                  _buildNavigationRow('Privacy Policies', () {}, theme),
                  const Divider(height: 1),
                  _buildNavigationRow('Help Center & FAQs', () {}, theme),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('App Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'v1.0.0 (Production)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, {required Widget child}) {
    return Card(
      elevation: 0,
      color: isDark ? const Color(0xFF161F30) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildNavigationRow(String title, VoidCallback onTap, ThemeData theme) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }
}
