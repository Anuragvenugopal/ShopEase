import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';

class AdminLoginForm extends StatefulWidget {
  const AdminLoginForm({super.key});

  @override
  State<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _completeAdminLogin() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isAdminLoggedIn', true);
    });
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authorized Admin Session Initialized!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.adminDashboard,
        (route) => false,
      );
    }
  }

  void _showError(String error) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification Failed: $error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onAdminLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _usernameController.text.trim().toLowerCase();
      final password = _passwordController.text;

      if (email == 'admin@shopease.com' && password == 'Admin@123') {
        
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((_) {
          _completeAdminLogin();
        }).catchError((e) {
          final errorStr = e.toString();
          if (errorStr.contains('user-not-found') ||
              errorStr.contains('INVALID_LOGIN_CREDENTIALS') ||
              errorStr.contains('invalid-credential')) {
            
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email, password: password)
                .then((cred) {
              
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(cred.user!.uid)
                  .set({
                'id': cred.user!.uid,
                'email': email,
                'displayName': 'Admin ShopEase',
                'createdAt': FieldValue.serverTimestamp(),
              }).then((_) {
                _completeAdminLogin();
              }).catchError((err) {
                
                _completeAdminLogin();
              });
            }).catchError((err) {
              _showError(err.toString());
            });
          } else {
            _showError(e.toString());
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Staff Credentials or Console Key! Access Denied.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),

        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.security_rounded,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrative Gate',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.amber[200] : Colors.amber[900],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Authorized operator logins only. Session audits active.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.amber[100] : Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),

        
        Center(
          child: Column(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Operation Dashboard',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter staff code and console key',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        
        Form(
          key: _formKey,
          child: Column(
            children: [
              
              CustomTextField(
                controller: _usernameController,
                labelText: 'Staff Login ID',
                hintText: 'admin@shopease.com',
                prefixIcon: Icons.badge_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Staff Login ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              
              CustomTextField(
                controller: _passwordController,
                labelText: 'Console Secret Key',
                hintText: '••••••••',
                isPassword: true,
                prefixIcon: Icons.vpn_key_outlined,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter console key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              
              CustomButton(
                text: 'Authenticate Console',
                isLoading: _isLoading,
                onPressed: _onAdminLogin,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
