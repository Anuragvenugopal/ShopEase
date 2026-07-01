import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/app_text.dart';
import './widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _slides = [
    OnboardingItem(
      title: 'Discover Latest Trends',
      description:
          'Explore thousands of premium products across multiple categories. Handpicked items just for your style.',
      imageUrl: AppAssets.onboardingTrends,
    ),
    OnboardingItem(
      title: 'Secure & Seamless Payment',
      description:
          'Shop with absolute peace of mind. We support safe payment cards, digital wallets, and cash on delivery.',
      imageUrl: AppAssets.onboardingPayments,
    ),
    OnboardingItem(
      title: 'Fast Delivery to Your Door',
      description:
          'Track your packages in real-time. Extremely secure packaging and lightning-fast logistics networks.',
      imageUrl: AppAssets.onboardingDelivery,
    ),
  ];

  void _onNextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — Skip button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _slides.length - 1)
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: AppText(
                        'Skip',
                        variant: AppTextVariant.labelLarge,
                        bold: true,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
            ),

            // Slide PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Curved image card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.38,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: isDark
                                    ? []
                                    : [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                              ),
                              child: SvgPicture.asset(
                                slide.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Slide title
                          AppText(
                            slide.title,
                            variant: AppTextVariant.displayMedium,
                            bold: true,
                            fontSize: 28,
                            letterSpacing: -0.5,
                            align: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Slide description
                          AppText(
                            slide.description,
                            variant: AppTextVariant.bodyMedium,
                            fontSize: 15,
                            height: 1.5,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom — indicators + button
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(_slides.length, (index) {
                      final isSelected = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        width: isSelected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Action button
                  CustomButton(
                    text: _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    width: 150,
                    onPressed: _onNextPage,
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