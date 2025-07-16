import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../models/address.dart' as app_address;
import '../../utility/app_color.dart';
import '../../utility/extensions.dart';
import '../../utility/snack_bar_helper.dart';
import '../address_screen/address_management_screen.dart';
import '../address_screen/provider/address_provider.dart';
import 'provider/cart_provider.dart';
import '../../widget/applay_coupon_btn.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/compleate_order_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  app_address.Address? _selectedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load user's default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      addressProvider.getDefaultAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer2<CartProvider, AddressProvider>(
        builder: (context, cartProvider, addressProvider, child) {
          if (cartProvider.myCartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address Section
                        _buildAddressSection(addressProvider),
                        const SizedBox(height: 24),

                        // Payment Method Section
                        _buildPaymentSection(cartProvider),
                        const SizedBox(height: 24),

                        // Coupon Section
                        _buildCouponSection(cartProvider),
                        const SizedBox(height: 24),

                        // Order Summary
                        _buildOrderSummary(cartProvider),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
                _buildBottomActionBar(cartProvider, addressProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressSection(AddressProvider addressProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blueAccent[400]),
                const SizedBox(width: 8),
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    // Navigate to AddressManagementScreen in add mode
                    await Get.to(
                      () =>
                          const AddressManagementScreen(isSelectionMode: false),
                    );
                    // Optionally, refresh the address list or select the new address
                    setState(
                      () {},
                    ); // This will rebuild and can trigger a refresh if needed
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add New'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedAddress != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _selectedAddress!.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedAddress!.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_selectedAddress!.isDefault == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'DEFAULT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_selectedAddress!.fullName != null &&
                        _selectedAddress!.fullName!.isNotEmpty)
                      Text(
                        _selectedAddress!.fullName!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.formattedAddress,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    if (_selectedAddress!.phone != null &&
                        _selectedAddress!.phone!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Phone: ${_selectedAddress!.phone}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _selectAddress(),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Change Address'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent[400],
                    side: BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No address selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please select a delivery address',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _selectAddress(),
                        icon: const Icon(Icons.add),
                        label: const Text('Select Address'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: Colors.blueAccent[400]),
                const SizedBox(width: 8),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropdown<String>(
              bgColor: Colors.white,
              hintText: cartProvider.selectedPaymentOption,
              items: const ['cod', 'prepaid'],
              onChanged: (val) {
                cartProvider.selectedPaymentOption = val ?? 'prepaid';
                cartProvider.updateUI();
              },
              displayItem: (val) =>
                  val == 'cod' ? 'Cash on Delivery' : 'Online Payment',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer, color: Colors.blueAccent[400]),
                const SizedBox(width: 8),
                const Text(
                  'Coupon Code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    height: 50,
                    labelText: 'Enter coupon code',
                    onSave: (value) {},
                    controller: cartProvider.couponController,
                  ),
                ),
                const SizedBox(width: 12),
                ApplyCouponButton(
                  onPressed: () {
                    cartProvider.checkCoupon();
                  },
                ),
              ],
            ),
            if (cartProvider.couponCodeDiscount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Coupon applied! Discount: ₹${cartProvider.couponCodeDiscount}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt, color: Colors.blueAccent[400]),
                const SizedBox(width: 8),
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Subtotal', '₹${cartProvider.getCartSubTotal()}'),
            _buildSummaryRow('Items', '${cartProvider.myCartItems.length}'),
            if (cartProvider.couponCodeDiscount > 0)
              _buildSummaryRow(
                'Discount',
                '-₹${cartProvider.couponCodeDiscount}',
                isDiscount: true,
              ),
            const Divider(),
            _buildSummaryRow(
              'Total',
              '₹${cartProvider.getGrandTotal()}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount
                  ? Colors.green[600]
                  : (isTotal ? Colors.blueAccent[400] : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    CartProvider cartProvider,
    AddressProvider addressProvider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: CompleteOrderButton(
          labelText: 'Complete Order • ₹${cartProvider.getGrandTotal()}',
          onPressed: _selectedAddress == null
              ? null
              : () => _processOrder(cartProvider),
        ),
      ),
    );
  }

  void _selectAddress() async {
    final result = await Get.to<app_address.Address>(
      () => const AddressManagementScreen(isSelectionMode: true),
    );

    print("result : $result");

    if (result != null) {
      print("inside the result");
      setState(() {
        print("setState called!!!");
        print("_selectedAddress : $_selectedAddress");
        _selectedAddress = result;
      });
    }
  }

  void _processOrder(CartProvider cartProvider) async {
    if (_selectedAddress == null) {
      SnackBarHelper.showErrorSnackBar('Please select a delivery address');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Store the selected address in cart provider for order processing
      cartProvider.selectedAddress = _selectedAddress;

      // Process the order
      await cartProvider.submitOrder(context);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error processing order: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
