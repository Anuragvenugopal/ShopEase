import 'package:flutter/material.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _activeStepIndex = 0;
  final _addressFormKey = GlobalKey<FormState>();

  // Shipping Address Fields
  final _fullNameController = TextEditingController(text: 'Jessica Doe');
  final _addressController = TextEditingController(text: '123 E-Commerce Blvd, Apt 4B');
  final _cityController = TextEditingController(text: 'New York');
  final _zipController = TextEditingController(text: '10001');
  final _phoneController = TextEditingController(text: '+1 (555) 019-2834');

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

  void _onStepContinue() {
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
      _placeOrder();
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

  void _placeOrder() {
    // Empty the in-memory cart since order is placed
    DummyData.cart.clear();
    
    // Redirect to Order Success Page
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.orderSuccess,
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtotal = DummyData.getCartTotal();
    final shipping = subtotal > 150 ? 0.0 : 15.00;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Checkout',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _activeStepIndex,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, controls) {
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: _activeStepIndex == 2 ? 'Place Order' : 'Continue',
                      onPressed: controls.onStepContinue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      isOutlined: true,
                      onPressed: controls.onStepCancel,
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
              title: const Text('Address'),
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
              title: const Text('Payment'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              title: const Text('Review'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Order Summary',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', theme),
                        const SizedBox(height: 8),
                        _buildRow('Shipping Cost', '\$${shipping.toStringAsFixed(2)}', theme),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 18,
                              ),
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
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04)),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: id,
        groupValue: _selectedPaymentMethod,
        title: Row(
          children: [
            Icon(icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onBackground.withOpacity(0.6)),
            const SizedBox(width: 12),
            Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
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
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04)),
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
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...details.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(d, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
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
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
