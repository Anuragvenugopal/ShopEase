import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/bottom_nav.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../../presentation/blocs/cart/cart_bloc.dart';
import '../../../presentation/blocs/cart/cart_event.dart';
import '../../../presentation/blocs/cart/cart_state.dart';
import '../../../presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../../presentation/blocs/wishlist/wishlist_event.dart';
import '../../../presentation/blocs/order/order_bloc.dart';
import '../../../presentation/blocs/order/order_event.dart';
import '../../../presentation/blocs/product/product_bloc.dart';
import '../../../presentation/blocs/product/product_event.dart';
import '../categories/categories_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import './widgets/shop_front_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && args != _currentTab) {
      setState(() => _currentTab = args);
    }
  }

  @override
  void initState() {
    super.initState();
    
    context.read<ProductBloc>().add(LoadProducts());
    
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CartBloc>().add(LoadCart(authState.user.id));
      context.read<WishlistBloc>().add(LoadWishlist(authState.user.id));
      context.read<OrderBloc>().add(LoadOrders(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> tabs = [
      ShopFrontView(
        onNavigateToTab: (index) => setState(() => _currentTab = index),
      ),
      const CategoriesScreen(),
      const WishlistScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    const List<String> tabTitles = [
      'ShopEase',
      'Categories',
      'My Wishlist',
      'Shopping Cart',
      'My Profile',
    ];

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartCount = cartState is CartLoaded ? cartState.totalItems : 0;

        return Scaffold(
          key: _scaffoldKey,
          drawer: const CustomDrawer(),
          appBar: CustomAppBar(
            title: tabTitles[_currentTab],
            showBackButton: false,
            showCartBadge: _currentTab != 3,
            cartCount: cartCount,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: AppColors.adaptive(
                    isDark: isDark,
                    lightColor: AppColors.overlayLight,
                    darkColor: AppColors.overlayDark,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
            ),
          ),
          body: IndexedStack(
            index: _currentTab,
            children: tabs,
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: _currentTab,
            onTap: (index) => setState(() => _currentTab = index),
            cartCount: cartCount,
          ),
        );
      },
    );
  }
}