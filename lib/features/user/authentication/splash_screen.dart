import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../../presentation/blocs/auth/auth_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    
    context.read<AuthBloc>().add(AuthCheckRequested());

    _navigationTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _timerFinished = true;
        _navigateBasedOnAuth();
      }
    });
  }

  void _navigateBasedOnAuth() async {
    if (!_timerFinished) return;
    
    final prefs = await SharedPreferences.getInstance();
    final isAdmin = prefs.getBool('isAdminLoggedIn') ?? false;

    if (mounted) {
      if (isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (authState is Unauthenticated || authState is AuthError) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      } else {
        
      }
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_timerFinished) {
          _navigateBasedOnAuth();
        }
      },
      child: Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D16) : Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(isDark ? 0.15 : 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary
                    .withOpacity(isDark ? 0.1 : 0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),

          
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.logo,
                        width: 72,
                        height: 72,
                      ),
                    ),
                    const SizedBox(height: 24),

                    
                    AppText(
                      'ShopEase',
                      variant: AppTextVariant.displayLarge,
                      fontWeight: FontWeight.w900,
                      fontSize: 38,
                      letterSpacing: -1.0,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),

                    
                    AppText(
                      'Your Premium Shopping Destination',
                      variant: AppTextVariant.bodyMedium,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          
          Positioned(
            bottom: 64,
            child: Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                AppText(
                  'v1.0.0',
                  variant: AppTextVariant.bodySmall,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
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