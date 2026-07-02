import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import './widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInRequested(_emailController.text.trim(), _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is Authenticated) {
          CustomToast.show(context, 'Login Success');
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isGoogleLoading = state is AuthLoading && state.isGoogle;
        final isEmailLoading = state is AuthLoading && !state.isGoogle;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.logo,
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const AppText(
                          'Welcome Back',
                          variant: AppTextVariant.displayMedium,
                          bold: true,
                          fontSize: 28,
                        ),
                        const SizedBox(height: 8),
                        const AppText(
                          'Sign in to explore custom fashion and collections',
                          variant: AppTextVariant.bodyMedium,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email or Username',
                          hintText: 'e.g. name@example.com or user123',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.person_outline_rounded,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email or username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: '••••••••',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.forgotPassword,
                                    );
                                  },
                            child: const AppText(
                              'Forgot Password?',
                              variant: AppTextVariant.labelLarge,
                              bold: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        CustomButton(
                          text: 'Sign In',
                          isLoading: isEmailLoading,
                          onPressed: isLoading ? null : _onLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Theme.of(context).dividerColor),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AppText(
                          'Or continue with',
                          variant: AppTextVariant.bodyMedium,
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Theme.of(context).dividerColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialButton(
                        assetPath: AppAssets.googleIcon,
                        isLoading: isGoogleLoading,
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  GoogleSignInRequested(),
                                );
                              },
                      ),
                      const SizedBox(width: 16),
                      SocialButton(
                        assetPath: AppAssets.facebookIcon,
                        onTap: isLoading
                            ? null
                            : () {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Facebook login not implemented',
                                    ),
                                  ),
                                );
                              },
                      ),
                      const SizedBox(width: 16),
                      SocialButton(
                        assetPath: AppAssets.appleIcon,
                        iconColor: isDark ? Colors.white : Colors.black,
                        onTap: isLoading
                            ? null
                            : () {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Apple login not implemented',
                                    ),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Center(
                    child: GestureDetector(
                      onTap: isLoading ? null : () =>
                          Navigator.pushNamed(context, AppRoutes.adminLogin),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          children: [
                            const TextSpan(text: "Are you an Admin? "),
                            TextSpan(
                              text: "Login here",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        "Don't have an account? ",
                        variant: AppTextVariant.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                        child: const AppText(
                          'Sign Up',
                          variant: AppTextVariant.labelLarge,
                          bold: true,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  
                  Center(
                    child: TextButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pushNamed(
                              context,
                              AppRoutes.adminLogin,
                            ),
                      icon: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 20,
                      ),
                      label: const AppText(
                        'Access Admin Portal',
                        variant: AppTextVariant.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
