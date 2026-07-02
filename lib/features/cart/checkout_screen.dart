import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/app_text.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/cart/cart_state.dart';
import '../../presentation/blocs/order/order_bloc.dart';
import '../../presentation/blocs/order/order_event.dart';
import '../../presentation/blocs/order/order_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _activeStepIndex = 0;
  final _addressFormKey = GlobalKey<FormState>();

  // Shipping Address Fields
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  // Payment Methods
  String _selectedPaymentMethod = 'card'; // card, google, cod

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onStepContinue(List<CartItemEntity> items, double total, String userId) {
    if (_activeStepIndex == 0) {
      if (_addressFormKey.currentState!.validate()) {
        setState(() {
          _activeStepIndex += 1;
        });
      }
    } else if (_activeStepIndex == 1) {
      setState(() {
        _activeStepIndex += 1;
      });
    } else {
      // Step 2: Finalize Purchase
      _placeOrder(items, total, userId);
    }
  }

  void _onStepCancel() {
    if (_activeStepIndex > 0) {
      setState(() {
        _activeStepIndex -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _placeOrder(List<CartItemEntity> items, double total, String userId) {
    if (userId.isEmpty) return;
    final address =
        '${_fullNameController.text}, ${_addressController.text}, ${_cityController.text}, ${_zipController.text}, Phone: ${_phoneController.text}';
    context.read<OrderBloc>().add(
          PlaceOrder(
            userId: userId,
            items: items,
            totalAmount: total,
            shippingAddress: address,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    final cartState = context.watch<CartBloc>().state;
    final List<CartItemEntity> items =
        cartState is CartLoaded ? cartState.items : [];
    final subtotal = cartState is CartLoaded ? cartState.subtotal : 0.0;
    final shipping = cartState is CartLoaded ? cartState.shipping : 0.0;
    final total = subtotal + shipping;

    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderPlaced) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.orderSuccess,
            (route) => route.settings.name == AppRoutes.home,
          );
        } else if (orderState is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(orderState.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, orderState) {
        final isOrderLoading = orderState is OrderLoading;

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Checkout',
            showBackButton: true,
          ),
          body: SafeArea(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _activeStepIndex,
              onStepContinue: () => _onStepContinue(items, total, userId),
              onStepCancel: _onStepCancel,
              controlsBuilder: (context, controls) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: _activeStepIndex == 2 ? 'Place Order' : 'Continue',
                          isLoading: isOrderLoading,
                          onPressed: isOrderLoading ? null : controls.onStepContinue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Back',
                          isOutlined: true,
                          onPressed: isOrderLoading ? null : controls.onStepCancel,
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: [
            // Step 1: Address Details
            Step(
              state: _activeStepIndex > 0 ? StepState.complete : StepState.editing,
              isActive: _activeStepIndex >= 0,
              title: const AppText('Address', variant: AppTextVariant.bodyLarge, bold: true),
              content: Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) => v == null || v.isEmpty ? 'Please enter recipient name' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      labelText: 'Street Address',
                      prefixIcon: Icons.home_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Please enter delivery address' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _cityController,
                            labelText: 'City',
                            validator: (v) => v == null || v.isEmpty ? 'Enter city' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _zipController,
                            labelText: 'ZIP Code',
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Enter ZIP' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Please enter phone number' : null,
                    ),
                  ],
                ),
              ),
            ),
            
            // Step 2: Payment Method Selection
            Step(
              state: _activeStepIndex > 1 ? StepState.complete : StepState.editing,
              isActive: _activeStepIndex >= 1,
              title: const AppText('Payment', variant: AppTextVariant.bodyLarge, bold: true),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Select Payment Method',
                    variant: AppTextVariant.titleMedium,
                    bold: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // Credit/Debit Card option
                  _buildPaymentRadioTile(
                    id: 'card',
                    title: 'Credit / Debit Card',
                    subtitle: 'Pay securely using VISA, MasterCard, or AMEX',
                    icon: Icons.credit_card_rounded,
                  ),
                  const SizedBox(height: 12),

                  // Google Pay option
                  _buildPaymentRadioTile(
                    id: 'google',
                    title: 'Google Pay',
                    subtitle: 'Instant secure payment via Google wallet',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 12),

                  // Cash on delivery option
                  _buildPaymentRadioTile(
                    id: 'cod',
                    title: 'Cash on Delivery (COD)',
                    subtitle: 'Pay with cash upon package receipt',
                    icon: Icons.payments_outlined,
                  ),
                ],
              ),
            ),
            
            // Step 3: Review summary
            Step(
              isActive: _activeStepIndex >= 2,
              title: const AppText('Review', variant: AppTextVariant.bodyLarge, bold: true),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppText(
                    'Order Summary',
                    variant: AppTextVariant.titleMedium,
                    bold: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // Delivery Details Preview
                  _buildReviewSectionCard(
                    title: 'Delivery Address',
                    details: [
                      _fullNameController.text,
                      _addressController.text,
                      '${_cityController.text}, ${_zipController.text}',
                      _phoneController.text,
                    ],
                    icon: Icons.local_shipping_outlined,
                    context: context,
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Preview
                  _buildReviewSectionCard(
                    title: 'Payment Details',
                    details: [
                      _selectedPaymentMethod == 'card'
                          ? 'Credit / Debit Card (Ending in •••• 4242)'
                          : _selectedPaymentMethod == 'google'
                              ? 'Google Pay Linked Wallet'
                              : 'Cash on Delivery (COD)',
                    ],
                    icon: Icons.payment_rounded,
                    context: context,
                  ),
                  const SizedBox(height: 16),

                  // Totals Preview Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.adaptive(
                        isDark: isDark,
                        lightColor: AppColors.searchBarLight,
                        darkColor: AppColors.searchBarDark,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}', theme),
                        const SizedBox(height: 8),
                        _buildRow('Shipping Cost', '₹${shipping.toStringAsFixed(0)}', theme),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppText('Grand Total', variant: AppTextVariant.bodyLarge, bold: true),
                            AppText(
                              '₹${total.toStringAsFixed(0)}',
                              variant: AppTextVariant.titleMedium,
                              bold: true,
                              color: theme.colorScheme.primary,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }

  Widget _buildPaymentRadioTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedPaymentMethod == id;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.adaptive(
          isDark: isDark,
          lightColor: AppColors.surfaceLight,
          darkColor: AppColors.surfaceDark,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : AppColors.adaptive(
                  isDark: isDark,
                  lightColor: AppColors.bentoBorderLight,
                  darkColor: AppColors.bentoBorderDark,
                ),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: id,
        groupValue: _selectedPaymentMethod,
        title: Row(
          children: [
            Icon(icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: AppText(
                title,
                variant: AppTextVariant.bodyLarge,
                bold: true,
                fontSize: 14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: AppText(
            subtitle,
            variant: AppTextVariant.bodyMedium,
            fontSize: 12,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedPaymentMethod = val;
            });
          }
        },
        activeColor: theme.colorScheme.primary,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  Widget _buildReviewSectionCard({
    required String title,
    required List<String> details,
    required IconData icon,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.adaptive(
          isDark: isDark,
          lightColor: AppColors.surfaceLight,
          darkColor: AppColors.surfaceDark,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.adaptive(
            isDark: isDark,
            lightColor: AppColors.bentoBorderLight,
            darkColor: AppColors.bentoBorderDark,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  variant: AppTextVariant.titleMedium,
                  fontSize: 15,
                  bold: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                ...details.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: AppText(
                      d,
                      variant: AppTextVariant.bodyMedium,
                      fontSize: 13,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: AppText(
            label,
            variant: AppTextVariant.bodyMedium,
            fontSize: 13,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        AppText(
          value,
          variant: AppTextVariant.bodyMedium,
          bold: true,
          fontSize: 13,
        ),
      ],
    );
  }
}