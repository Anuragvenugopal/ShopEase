import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../main.dart'; 
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';

import './widgets/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (route) => false);
        }
      },
      child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              
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
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final photoUrl = state is Authenticated
                                    ? state.user.photoUrl
                                    : null;
                                return CircleAvatar(
                                  backgroundImage: photoUrl != null
                                      ? NetworkImage(photoUrl)
                                      : const NetworkImage(
                                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final name = state is Authenticated
                            ? (state.user.displayName ?? 'User')
                            : 'User';
                        final email = state is Authenticated
                            ? state.user.email
                            : '';
                        return Column(
                          children: [
                            AppText(
                              name,
                              variant: AppTextVariant.titleLarge,
                              bold: true,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              email,
                              variant: AppTextVariant.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),


              
              const AppText(
                'Account Settings',
                variant: AppTextVariant.titleMedium,
                bold: true,
                fontSize: 16,
              ),
              const SizedBox(height: 12),
              ProfileMenuTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Personal Details',
                onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
              ),

              ProfileMenuTile(
                icon: Icons.settings_outlined,
                title: 'App Settings',
                onTap: () => Navigator.pushNamed(context, AppRoutes.settingsRoute),
              ),

              const Divider(height: 32),

              
              const AppText(
                'Developer Tools',
                variant: AppTextVariant.titleMedium,
                bold: true,
                fontSize: 16,
              ),
              const SizedBox(height: 12),

              
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (_, currentMode, __) {
                  final isCurrentlyDark = currentMode == ThemeMode.dark;
                  return Card(
                    elevation: 0,
                    color: AppColors.adaptive(
                      isDark: isDark,
                      lightColor: AppColors.surfaceLight,
                      darkColor: AppColors.surfaceDark,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.adaptive(
                          isDark: isDark,
                          lightColor: AppColors.bentoBorderLight,
                          darkColor: AppColors.bentoBorderDark,
                        ),
                      ),
                    ),
                    child: SwitchListTile.adaptive(
                      title: AppText(
                        'Dark Theme Mode',
                        variant: AppTextVariant.bodyLarge,
                        bold: true,
                        fontSize: 14,
                      ),
                      subtitle: const AppText('Toggle app visualization', variant: AppTextVariant.bodyMedium, fontSize: 11),
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
              
              ProfileMenuTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Switch to Admin Module',
                onTap: () => Navigator.pushNamed(context, AppRoutes.adminLogin),
                tileColor: theme.colorScheme.primary.withOpacity(0.08),
                iconColor: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),
              
              
              ElevatedButton.icon(
                onPressed: () {
                  ConfirmationDialog.show(
                    context,
                    title: 'Log Out',
                    content: 'Are you sure you want to log out of your ShopEase account?',
                    confirmText: 'Log Out',
                    cancelText: 'Cancel',
                    isDangerous: true,
                    onConfirm: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const AppText('Log Out Account', variant: AppTextVariant.bodyMedium, bold: true),
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
      ),
    );
  }
}