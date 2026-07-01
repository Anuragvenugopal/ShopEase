import 'package:flutter/material.dart';
import 'fade_slide_page_route.dart';
import '../../features/authentication/pages/splash_page.dart';
import '../../features/authentication/pages/onboarding_page.dart';
import '../../features/authentication/pages/login_page.dart';
import '../../features/authentication/pages/register_page.dart';
import '../../features/authentication/pages/forgot_password_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/categories/pages/categories_page.dart';
import '../../features/categories/pages/category_products_page.dart';
import '../../features/products/pages/product_details_page.dart';
import '../../features/search/pages/search_page.dart';
import '../../features/wishlist/pages/wishlist_page.dart';
import '../../features/cart/pages/cart_page.dart';
import '../../features/cart/pages/checkout_page.dart';
import '../../features/orders/pages/order_success_page.dart';
import '../../features/orders/pages/order_history_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/settings_page.dart';
import '../../features/admin/pages/admin_login_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';
import '../../features/admin/pages/admin_product_list_page.dart';
import '../../features/admin/pages/admin_add_product_page.dart';
import '../../features/admin/pages/admin_edit_product_page.dart';
import '../../features/admin/pages/admin_categories_page.dart';
import '../../features/admin/pages/admin_orders_page.dart';
import '../../features/admin/pages/admin_low_stock_page.dart';
import '../../features/admin/pages/admin_barcode_scanner_page.dart';
import '../../features/admin/pages/admin_sku_search_page.dart';

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
  static const String orderHistory = '/order-history';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage(), settings);
      case onboarding:
        return _buildRoute(const OnboardingPage(), settings);
      case login:
        return _buildRoute(const LoginPage(), settings);
      case register:
        return _buildRoute(const RegisterPage(), settings);
      case forgotPassword:
        return _buildRoute(const ForgotPasswordPage(), settings);
      case home:
        return _buildRoute(const HomePage(), settings);
      case categories:
        return _buildRoute(const CategoriesPage(), settings);
      case categoryProducts:
        final categoryName = settings.arguments as String? ?? 'Category';
        return _buildRoute(CategoryProductsPage(categoryName: categoryName), settings);
      case productDetails:
        final productId = settings.arguments as String? ?? '1';
        return _buildRoute(ProductDetailsPage(productId: productId), settings);
      case search:
        return _buildRoute(const SearchPage(), settings);
      case wishlist:
        return _buildRoute(const WishlistPage(), settings);
      case cart:
        return _buildRoute(const CartPage(), settings);
      case checkout:
        return _buildRoute(const CheckoutPage(), settings);
      case orderSuccess:
        return _buildRoute(const OrderSuccessPage(), settings);
      case orderHistory:
        return _buildRoute(const OrderHistoryPage(), settings);
      case profile:
        return _buildRoute(const ProfilePage(), settings);
      case editProfile:
        return _buildRoute(const EditProfilePage(), settings);
      case settingsRoute: // named specifically to avoid conflict with standard flutter keywords if any
        return _buildRoute(const SettingsPage(), settings);
      case adminLogin:
        return _buildRoute(const AdminLoginPage(), settings);
      case adminDashboard:
        return _buildRoute(const AdminDashboardPage(), settings);
      case adminProductList:
        return _buildRoute(const AdminProductListPage(), settings);
      case adminAddProduct:
        return _buildRoute(const AdminAddProductPage(), settings);
      case adminEditProduct:
        final productId = settings.arguments as String? ?? '';
        return _buildRoute(AdminEditProductPage(productId: productId), settings);
      case adminCategories:
        return _buildRoute(const AdminCategoriesPage(), settings);
      case adminOrders:
        return _buildRoute(const AdminOrdersPage(), settings);
      case adminLowStock:
        return _buildRoute(const AdminLowStockPage(), settings);
      case adminBarcodeScanner:
        return _buildRoute(const AdminBarcodeScannerPage(), settings);
      case adminSkuSearch:
        return _buildRoute(const AdminSkuSearchPage(), settings);
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
