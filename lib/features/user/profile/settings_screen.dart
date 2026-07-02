import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_text.dart';
import './widgets/settings_card.dart';
import './widgets/settings_section_header.dart';
import './widgets/settings_navigation_row.dart';
import '../../../core/widgets/custom_toast.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'App Settings',
        showBackButton: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            
            const SettingsSectionHeader(label: 'Notifications'),
            SettingsCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const AppText('Push Notifications', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                    subtitle: const AppText('Coming soon', variant: AppTextVariant.bodyMedium, fontSize: 11),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => CustomToast.show(context, '🔔 Push Notifications — Coming Soon!'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const AppText('Email Newsletters', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                    subtitle: const AppText('Coming soon', variant: AppTextVariant.bodyMedium, fontSize: 11),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => CustomToast.show(context, '📧 Email Newsletters — Coming Soon!'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            
            const SettingsSectionHeader(label: 'Security & Biometrics'),
            SettingsCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.fingerprint_rounded),
                    title: const AppText('Enable FaceID / TouchID', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                    subtitle: const AppText('Coming soon', variant: AppTextVariant.bodyMedium, fontSize: 11),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => CustomToast.show(context, '🔐 Biometric Login — Coming Soon!'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded),
                    title: const AppText('Change Account Password', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                    subtitle: const AppText('Coming soon', variant: AppTextVariant.bodyMedium, fontSize: 11),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => CustomToast.show(context, '🔑 Change Password — Coming Soon!'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            
            const SettingsSectionHeader(label: 'Regional Preferences'),
            SettingsCard(
              child: ListTile(
                leading: const Icon(Icons.language_rounded),
                title: const AppText('App Language', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                subtitle: const AppText('Multi-language support coming soon', variant: AppTextVariant.bodyMedium, fontSize: 11),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () => CustomToast.show(context, '🌐 App Language — Coming Soon!'),
              ),
            ),
            const SizedBox(height: 24),

            
            const SettingsSectionHeader(label: 'Support & Legal'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsNavigationRow(title: 'Terms of Service',  onTap: () => CustomToast.show(context, '📄 Terms of Service — Coming Soon!')),
                  const Divider(height: 1),
                  SettingsNavigationRow(title: 'Privacy Policies',  onTap: () => CustomToast.show(context, '🔒 Privacy Policy — Coming Soon!')),
                  const Divider(height: 1),
                  SettingsNavigationRow(title: 'Help Center & FAQs', onTap: () => CustomToast.show(context, '🤝 Help Center — Coming Soon!')),
                  const Divider(height: 1),
                  ListTile(
                    title: const AppText('App Version', variant: AppTextVariant.bodyLarge, bold: true, fontSize: 14),
                    trailing: AppText(
                      'v1.0.0 (Production)',
                      variant: AppTextVariant.bodyMedium,
                      bold: true,
                      color: theme.colorScheme.primary,
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
}