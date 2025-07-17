import 'package:ecom_client/utility/snack_bar_helper.dart';

import '../../auth_screen/login_screen/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/address.dart';
import '../../../models/api_response.dart';
import '../../../models/order.dart';
import '../../../services/http_services.dart';

class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  // final UserProvider _userProvider;

  Address? shippingAddress;
  Address? billingAddress;
  bool isLoading = false;
  bool isOrderLoading = false;
  // OrderProvider(this._userProvider);

  /// Fetches addresses by their IDs. Returns the fetched shipping address, or null if not found.
  Future<Address?> fetchAddresses({
    String? shippingAddressID,
    String? billingAddressID,
  }) async {
    isLoading = true;
    notifyListeners();

    Address? fetchedShipping;
    Address? fetchedBilling;

    if (shippingAddressID != null && shippingAddressID.isNotEmpty) {
      final response = await service.getItems(
        endpointUrl: 'address/getAddressById/$shippingAddressID',
        withAuth: true,
      );

      if (response.isOk && response.body != null) {
        final addressJson = response.body['data'];

        shippingAddress = Address.fromJson(addressJson);

        fetchedShipping = shippingAddress;
      }
    }

    if (billingAddressID != null && billingAddressID.isNotEmpty) {
      final response = await service.getItems(
        endpointUrl: 'address/getAddressById/$billingAddressID',
        withAuth: true,
      );

      if (response.isOk && response.body != null) {
        final addressJson = response.body['data'];

        billingAddress = Address.fromJson(addressJson);

        fetchedBilling = billingAddress;
      }
    }

    isLoading = false;
    notifyListeners();

    return fetchedShipping ?? fetchedBilling;
  }

  // Cancel an order by updating its status to 'cancelled'
  Future<Order?> cancelOrder(String orderId) async {
    try {
      isOrderLoading = true;
      notifyListeners();
      final response = await service.updateItem(
        endpointUrl: 'orders',
        itemId: orderId,
        itemData: {"orderStatus": "cancelled"},
        withAuth: true,
      );

      print("response :: $response");

      if (response.isOk) {
        print("response.isOk!!");
        SnackBarHelper.showSuccessSnackBar('Order cancelled successfully.');
        // Refresh orders after cancellation
        // await fetchAllData();
      } else {
        print("Failed to cancel order.");
        SnackBarHelper.showErrorSnackBar('Failed to cancel order.');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    } finally {
      isOrderLoading = false;
      notifyListeners();
    }
    return null;
  }

  void clearAddresses() {
    shippingAddress = null;
    billingAddress = null;
    notifyListeners();
  }
}
