import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../presentation/blocs/product/product_bloc.dart';
import '../../../../presentation/blocs/product/product_event.dart';
import './banner_carousel.dart';
import './home_search_bar.dart';
import './home_section_header.dart';
import './home_category_list.dart';
import './promo_bento.dart';
import './trending_products_grid.dart';





class ShopFrontView extends StatelessWidget {
  const ShopFrontView({
    super.key,
    required this.onNavigateToTab,
  });

  
  
  final ValueChanged<int> onNavigateToTab;

  static const List<String> _banners = [
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(LoadProducts());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const HomeSearchBar(),
            const SizedBox(height: 20),

            
            const BannerCarousel(banners: _banners),
            const SizedBox(height: 24),

            
            HomeSectionHeader(
              title: 'Categories',
              onSeeAll: () => onNavigateToTab(1),
            ),
            const SizedBox(height: 16),
            const HomeCategoryList(),

            
            const SizedBox(height: 24),
            const HomeSectionHeader(title: 'Deals & Offers'),
            const SizedBox(height: 16),
            const PromoBento(),

            
            const SizedBox(height: 28),
            const HomeSectionHeader(title: 'Trending Products'),
            const SizedBox(height: 16),
            TrendingProductsGrid(
              onNavigateToCart: () => onNavigateToTab(3),
            ),

            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }
}
