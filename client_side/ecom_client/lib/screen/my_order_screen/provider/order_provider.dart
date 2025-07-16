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

    print("shippingAddressID? ::$shippingAddressID");
    print("billingAddressID? ::$billingAddressID");

    if (shippingAddressID != null && shippingAddressID.isNotEmpty) {
      final response = await service.getItems(
        endpointUrl: 'address/getAddressById/$shippingAddressID',
        withAuth: true,
      );
      print("response : $response");
      if (response.isOk && response.body != null) {
        final addressJson = response.body['data'];
        print('Shipping address data: $addressJson');

        shippingAddress = Address.fromJson(addressJson);

        fetchedShipping = shippingAddress;
      }
    }

    if (billingAddressID != null && billingAddressID.isNotEmpty) {
      final response = await service.getItems(
        endpointUrl: 'address/getAddressById/$billingAddressID',
        withAuth: true,
      );
      print("response : $response");
      if (response.isOk && response.body != null) {
        final addressJson = response.body['data'];
        print('Shipping address data: $addressJson');

        billingAddress = Address.fromJson(addressJson);

        fetchedBilling = billingAddress;
      }
    }

    isLoading = false;
    notifyListeners();

    return fetchedShipping ?? fetchedBilling;
  }

  void clearAddresses() {
    shippingAddress = null;
    billingAddress = null;
    notifyListeners();
  }
}


// if (response.isOk) {
//         ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
//         if (apiResponse.success == true) {
//           SnackBarHelper.showSuccessSnackBar(apiResponse.message);
//           log('Order added');
//           clearCouponDiscount();
//           clearCartItems();
//           Navigator.pop(context);
//         } else {
//           SnackBarHelper.showErrorSnackBar(
//             'Failed to add Order: ${apiResponse.message}',
//           );
//         }
//       } else {
//         SnackBarHelper.showErrorSnackBar(
//           'Error ${response.body?['message'] ?? response.statusText}',
//         );
//       }
//     } catch (e) {
//       print(e);
//       SnackBarHelper.showErrorSnackBar('An error occurred: $e');
//       rethrow;
//     }