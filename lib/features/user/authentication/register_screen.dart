import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        CustomToast.show(context, 'Please accept the Terms & Conditions to proceed');
        return;
      }

      context.read<AuthBloc>().add(
        SignUpRequested(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          CustomToast.show(context, 'Account created successfully!');
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (route) => false);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: const AppText(
              'Create Account',
              variant: AppTextVariant.titleMedium,
              bold: true,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const AppText(
                    'Join ShopEase Today',
                    variant: AppTextVariant.displayMedium,
                    bold: true,
                    fontSize: 26,
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const AppText(
                    'Fill in the details below to open your shopping account',
                    variant: AppTextVariant.bodyMedium,
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'John Doe',
                          prefixIcon: Icons.person_outline_rounded,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().split(' ').length < 2) {
                              return 'Please enter your full name (first and last)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email Address',
                          hintText: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
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
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          hintText: '••••••••',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: isLoading ? null : (val) {
                          setState(() => _agreeToTerms = val ?? false);
                        },
                        activeColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            const AppText(
                              'I agree to the ',
                              variant: AppTextVariant.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const AppText(
                                'Terms of Service',
                                variant: AppTextVariant.labelLarge,
                                bold: true,
                              ),
                            ),
                            const AppText(
                              ' and ',
                              variant: AppTextVariant.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const AppText(
                                'Privacy Policy',
                                variant: AppTextVariant.labelLarge,
                                bold: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Create Account',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onSignUp,
                  ),
                  const SizedBox(height: 32),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        'Already have an account? ',
                        variant: AppTextVariant.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: isLoading ? null : () => Navigator.pop(context),
                        child: const AppText(
                          'Sign In',
                          variant: AppTextVariant.labelLarge,
                          bold: true,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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