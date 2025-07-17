import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/address.dart';
import '../../../models/api_response.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../auth_screen/login_screen/provider/user_provider.dart';

class AddressProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final UserProvider _userProvider;

  List<Address> _addresses = [];
  Address? _defaultAddress;
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  // Getters
  List<Address> get addresses => _addresses;
  Address? get defaultAddress => _defaultAddress;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;

  AddressProvider(this._userProvider);

  // Get all addresses for the user
  Future<void> getUserAddresses() async {
    try {
      _isLoading = true;
      notifyListeners();
      final UserID = _userProvider.getLoginUsr()?.sId ?? '';

      final response = await service.getItems(
        endpointUrl: 'address/getAllAddressByUserID/$UserID',
        withAuth: true,
      );

      if (response.isOk) {
        
        ApiResponse<List<Address>> apiResponse =
            ApiResponse<List<Address>>.fromJson(
              response.body,
              (json) => (json as List)
                  .map((item) => Address.fromJsonObject(item))
                  .toList(),
            );

        _addresses = apiResponse.data ?? [];
        _defaultAddress = _addresses
            .where((addr) => addr.isDefault == true)
            .firstOrNull;

        notifyListeners();
      } else {
        print(
          'AddressProvider: Failed to fetch addresses - ${response.statusCode}',
        );
        SnackBarHelper.showErrorSnackBar('Failed to load addresses');
      }
    } catch (e) {
      print('AddressProvider: Error fetching addresses: $e');
      SnackBarHelper.showErrorSnackBar('Error loading addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get default address
  Future<void> getDefaultAddress() async {
    try {
      final response = await service.getItems(
        endpointUrl: 'address/default',
        withAuth: true,
      );

      if (response.isOk) {
        ApiResponse<Address> apiResponse = ApiResponse<Address>.fromJson(
          response.body,
          (json) => Address.fromJsonObject(json),
        );

        _defaultAddress = apiResponse.data;
        notifyListeners();
      } else {
        print('AddressProvider: No default address found');
        _defaultAddress = null;
        notifyListeners();
      }
    } catch (e) {
      print('AddressProvider: Error fetching default address: $e');
      _defaultAddress = null;
      notifyListeners();
    }
  }

  // Get address by ID
  Future<Address?> getAddressById(String addressId) async {
    try {
      final response = await service.getItems(
        endpointUrl: 'address/$addressId',
        withAuth: true,
      );

      if (response.isOk) {
        ApiResponse<Address> apiResponse = ApiResponse<Address>.fromJson(
          response.body,
          (json) => Address.fromJsonObject(json),
        );

        return apiResponse.data;
      } else {
        print('AddressProvider: Address not found');
        return null;
      }
    } catch (e) {
      print('AddressProvider: Error fetching address: $e');
      return null;
    }
  }

  // Add new address
  Future<bool> addAddress(Address address) async {
    try {
      _isAdding = true;
      notifyListeners();

      // Prepare address data
      final addressData = {
        "userID": _userProvider.getLoginUsr()?.sId ?? '',
        'addressType': address.addressType,
        'label': address.label,
        'fullName': address.fullName,
        'phone': address.phone,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'postalCode': address.postalCode,
        'country': address.country,
        'isDefault': address.isDefault ?? false,
      };

      final response = await service.addItem(
        endpointUrl: 'address',
        itemData: addressData,
      );

      if (response.isOk) {
        ApiResponse<Address> apiResponse = ApiResponse<Address>.fromJson(
          response.body,
          (json) => Address.fromJsonObject(json),
        );

        final newAddress = apiResponse.data;
        if (newAddress != null) {
          _addresses.add(newAddress);

          // If this is set as default, update other addresses
          if (newAddress.isDefault == true) {
            for (var addr in _addresses) {
              if (addr.sId != newAddress.sId) {
                addr.isDefault = false;
              }
            }
            _defaultAddress = newAddress;
          }

          SnackBarHelper.showSuccessSnackBar('Address added successfully');
          notifyListeners();
          return true;
        }
      } else {
        print(
          'AddressProvider: Failed to add address - ${response.statusCode}',
        );
        SnackBarHelper.showErrorSnackBar('Failed to add address');
      }
    } catch (e) {
      print('AddressProvider: Error adding address: $e');
      SnackBarHelper.showErrorSnackBar('Error adding address: $e');
    } finally {
      _isAdding = false;
      notifyListeners();
    }
    return false;
  }

  // Update address
  Future<bool> updateAddress(Address address) async {
    try {
      _isUpdating = true;
      notifyListeners();

      // Prepare address data
      final addressData = {
        "userID": _userProvider.getLoginUsr()?.sId ?? '',
        'addressType': address.addressType,
        'label': address.label,
        'fullName': address.fullName,
        'phone': address.phone,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'postalCode': address.postalCode,
        'country': address.country,
        'isDefault': address.isDefault ?? false,
      };

      final response = await service.updateItem(
        endpointUrl: 'address',
        itemId: address.sId!,
        itemData: addressData,
        withAuth: true,
      );

      if (response.isOk) {
        ApiResponse<Address> apiResponse = ApiResponse<Address>.fromJson(
          response.body,
          (json) => Address.fromJsonObject(json),
        );

        final updatedAddress = apiResponse.data;
        if (updatedAddress != null) {
          final index = _addresses.indexWhere(
            (addr) => addr.sId == address.sId,
          );
          if (index != -1) {
            _addresses[index] = updatedAddress;

            // If this is set as default, update other addresses
            if (updatedAddress.isDefault == true) {
              for (var addr in _addresses) {
                if (addr.sId != updatedAddress.sId) {
                  addr.isDefault = false;
                }
              }
              _defaultAddress = updatedAddress;
            }
          }

          SnackBarHelper.showSuccessSnackBar('Address updated successfully');
          notifyListeners();
          return true;
        }
      } else {
        print(
          'AddressProvider: Failed to update address - ${response.statusCode}',
        );
        SnackBarHelper.showErrorSnackBar('Failed to update address');
      }
    } catch (e) {
      print('AddressProvider: Error updating address: $e');
      SnackBarHelper.showErrorSnackBar('Error updating address: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
    return false;
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      _isDeleting = true;
      notifyListeners();

      final response = await service.deleteItem(
        endpointUrl: 'address',
        itemId: addressId,
      );

      if (response.isOk) {
        _addresses.removeWhere((addr) => addr.sId == addressId);

        // If deleted address was default, set first address as default
        if (_defaultAddress?.sId == addressId) {
          _defaultAddress = _addresses.isNotEmpty ? _addresses.first : null;
        }

        SnackBarHelper.showSuccessSnackBar('Address deleted successfully');
        notifyListeners();
        return true;
      } else {
        print(
          'AddressProvider: Failed to delete address - ${response.statusCode}',
        );
        SnackBarHelper.showErrorSnackBar('Failed to delete address');
      }
    } catch (e) {
      print('AddressProvider: Error deleting address: $e');
      SnackBarHelper.showErrorSnackBar('Error deleting address: $e');
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
    return false;
  }

  // Set address as default
  Future<bool> setDefaultAddress(String addressId) async {
    try {
      // Prepare address data
      final addressData = {
        'userID': _userProvider.getLoginUsr()?.sId ?? '',
        'isDefault': true,
      };

      final response = await service.updateItem(
        endpointUrl: 'address/setDefaultAddress',
        itemId: addressId,
        itemData: addressData,
        withAuth: true,
      );

      if (response.isOk) {
        // Update local state
        for (var addr in _addresses) {
          addr.isDefault = addr.sId == addressId;
        }
        _defaultAddress = _addresses
            .where((addr) => addr.sId == addressId)
            .firstOrNull;

        SnackBarHelper.showSuccessSnackBar('Default address updated');
        notifyListeners();
        return true;
      } else {
        print(
          'AddressProvider: Failed to set default address - ${response.statusCode}',
        );
        SnackBarHelper.showErrorSnackBar('Failed to set default address');
      }
    } catch (e) {
      print('AddressProvider: Error setting default address: $e');
      SnackBarHelper.showErrorSnackBar('Error setting default address: $e');
    }
    return false;
  }

  // Helper method to get addresses by type
  List<Address> getAddressesByType(String type) {
    return _addresses
        .where((addr) => addr.addressType?.toLowerCase() == type.toLowerCase())
        .toList();
  }

  // Helper method to check if address exists
  bool hasAddress(String addressId) {
    return _addresses.any((addr) => addr.sId == addressId);
  }

  // Helper method to get address by ID from local list
  Address? getAddressByIdLocal(String addressId) {
    try {
      return _addresses.firstWhere((addr) => addr.sId == addressId);
    } catch (e) {
      return null;
    }
  }

  // Refresh all addresses
  Future<void> refreshAddresses() async {
    await getUserAddresses();
  }
}
