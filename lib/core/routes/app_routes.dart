import 'package:flutter/material.dart';
import './fade_slide_page_route.dart';
import '../../features/authentication/splash_screen.dart';
import '../../features/authentication/onboarding_screen.dart';
import '../../features/authentication/login_screen.dart';
import '../../features/authentication/register_screen.dart';
import '../../features/authentication/forgot_password_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/categories/category_products_screen.dart';
import '../../features/products/product_details_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/cart/checkout_screen.dart';
import '../../features/orders/order_success_screen.dart';

import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/admin/admin_login_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/admin_product_list_screen.dart';
import '../../features/admin/admin_add_product_screen.dart';
import '../../features/admin/admin_edit_product_screen.dart';
import '../../features/admin/admin_categories_screen.dart';
import '../../features/admin/admin_orders_screen.dart';
import '../../features/admin/admin_low_stock_screen.dart';
import '../../features/admin/admin_barcode_scanner_screen.dart';
import '../../features/admin/admin_sku_search_screen.dart';
import '../../features/admin/admin_users_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String productDetails = '/product-details';
  static const String search = '/search';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  static const String adminLogin = '/admin-login';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminProductList = '/admin-products';
  static const String adminAddProduct = '/admin-add-product';
  static const String adminEditProduct = '/admin-edit-product';
  static const String adminCategories = '/admin-categories';
  static const String adminOrders = '/admin-orders';
  static const String adminLowStock = '/admin-low-stock';
  static const String adminBarcodeScanner = '/admin-barcode-scanner';
  static const String adminSkuSearch = '/admin-sku-search';
  static const String adminUsers = '/admin-users';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      case onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case register:
        return _buildRoute(const RegisterScreen(), settings);
      case forgotPassword:
        return _buildRoute(const ForgotPasswordScreen(), settings);
      case home:
        return _buildRoute(const HomeScreen(), settings);
      case categories:
        return _buildRoute(const CategoriesScreen(), settings);
      case categoryProducts:
        final categoryName = settings.arguments as String? ?? 'Category';
        return _buildRoute(CategoryProductsScreen(categoryName: categoryName), settings);
      case productDetails:
        final productId = settings.arguments as String? ?? '1';
        return _buildRoute(ProductDetailsScreen(productId: productId), settings);
      case search:
        return _buildRoute(const SearchScreen(), settings);
      case wishlist:
        return _buildRoute(const WishlistScreen(), settings);
      case cart:
        return _buildRoute(const CartScreen(), settings);
      case checkout:
        return _buildRoute(const CheckoutScreen(), settings);
      case orderSuccess:
        return _buildRoute(const OrderSuccessScreen(), settings);

      case profile:
        return _buildRoute(const ProfileScreen(), settings);
      case editProfile:
        return _buildRoute(const EditProfileScreen(), settings);
      case settingsRoute: // named specifically to avoid conflict with standard flutter keywords if any
        return _buildRoute(const SettingsScreen(), settings);
      case adminLogin:
        return _buildRoute(const AdminLoginScreen(), settings);
      case adminDashboard:
        return _buildRoute(const AdminDashboardScreen(), settings);
      case adminProductList:
        return _buildRoute(AdminProductListScreen(), settings);
      case adminAddProduct:
        return _buildRoute(const AdminAddProductScreen(), settings);
      case adminEditProduct:
        final productId = settings.arguments as String? ?? '';
        return _buildRoute(AdminEditProductScreen(productId: productId), settings);
      case adminCategories:
        return _buildRoute(const AdminCategoriesScreen(), settings);
      case adminOrders:
        return _buildRoute(const AdminOrdersScreen(), settings);
      case adminLowStock:
        return _buildRoute(const AdminLowStockScreen(), settings);
      case adminBarcodeScanner:
        return _buildRoute(const AdminBarcodeScannerScreen(), settings);
      case adminSkuSearch:
        return _buildRoute(AdminSkuSearchScreen(), settings);
      case adminUsers:
        return _buildRoute(const AdminUsersScreen(), settings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  // Use settingsRoute constant instead of settings
  static const String settingsRoute = '/settings';

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return FadeSlidePageRoute(page: page, settings: settings);
  }
}