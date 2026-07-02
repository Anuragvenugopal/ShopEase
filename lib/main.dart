import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme_data.dart';
import 'core/di/injection.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/product/product_event.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/wishlist/wishlist_bloc.dart';
import 'presentation/blocs/order/order_bloc.dart';
import 'presentation/blocs/admin_stats/admin_stats_bloc.dart';
import 'presentation/blocs/admin_stats/admin_stats_event.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<ProductBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<CartBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<WishlistBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<OrderBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AdminStatsBloc>()..add(FetchAdminStats()),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, currentThemeMode, __) {
          return MaterialApp(
            title: 'ShopEase',
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            themeMode: currentThemeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}