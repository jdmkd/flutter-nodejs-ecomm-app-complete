import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/data/data_provider.dart';
import '../../../../models/api_response.dart';
import '../../../../models/user.dart';
import '../../../../utility/snack_bar_helper.dart';
import '../../../../utility/constants.dart';
import '../../../../services/http_services.dart';
import '../login_screen.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final box = GetStorage();

  UserProvider(this._dataProvider);

  Future<String?> login(String email, String password) async {
    try {
      Map<String, dynamic> credentials = {"email": email, "password": password};

      final response = await service.addItem(
          endpointUrl: 'users/login', itemData: credentials);

      log('Attempting Login with: $email - $password');

      log('Login API Response: ${response.body}');
      if (response.isOk) {
        final ApiResponse<Map<String, dynamic>> apiResponse =
            ApiResponse<Map<String, dynamic>>.fromJson(
                response.body, (json) => json as Map<String, dynamic>);
        if (apiResponse.success ?? false) {
          Map<String, dynamic>? userData = apiResponse.data?['user'];
          String? token = apiResponse.data?['token'];
          log("userData ==>>> $userData");

          if (userData != null && token != null) {
            User user = User.fromJson(userData); // Create a User object
            await saveLoginInfo(user, token); // Save correct user info

            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            log('Login success: ${user.toJson()}');
            return null;
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to extract user data.');
            return 'Failed to extract user data.';
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Login: ${apiResponse.message}');
          return 'Failed to Login';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            '${response.body?['message'] ?? response.statusText}');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      Map<String, dynamic> user = {
        "name": name.toLowerCase(),
        "email": email,
        "password": password
      };
      final response =
          await service.addItem(endpointUrl: 'users/register', itemData: user);

      log("Response Body:::::::::: ${response.body}");

      // Check if response is null
      if (response == null) {
        SnackBarHelper.showErrorSnackBar('Server did not return a response.');
        return 'Server did not return a response.';
      }

      // Check if response body is null
      if (response.body == null) {
        SnackBarHelper.showErrorSnackBar('Server response is empty.');
        return 'Server response is empty.';
      }
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        // Check if apiResponse is valid and has success key
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              apiResponse.message ?? 'Registration successful');
          log('Register Success');
          // Get.to(() => OtpVerificationScreen(email: email));
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Register: ${apiResponse.message ?? "Unknown error"}');
          return 'Failed to Register: ${apiResponse.message ?? "Unknown error"}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            '${response.body?['message'] ?? response.statusText}');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (e, stackTrace) {
      log("Registration error: $e");
      log("Stack Trace: $stackTrace");

      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  Future<String?> verifyOtp(
      String email, String otp, BuildContext context) async {
    try {
      Map<String, dynamic> user = {"email": email, "otp": otp, "purpose": 0};
      // purpose=0 for registraion purpose=1 for the forgot password
      final response = await service.addItem(
          endpointUrl: 'users/verify-otp', itemData: user);

      // Check if response is null
      if (response == null) {
        SnackBarHelper.showErrorSnackBar('Server did not return a response.');
        return 'Server did not return a response.';
      }

      // Check if response body is null
      if (response.body == null) {
        SnackBarHelper.showErrorSnackBar('Server response is empty.');
        return 'Server response is empty.';
      }

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        // Check if apiResponse is valid and has success key
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              apiResponse.message ?? 'OTP Verified.');
          log('apiResponse.message ==> $apiResponse.message');
          // Navigate to the login screen (or dashboard)
          Get.offAll(() =>
              LoginScreen()); // Use Get.offAll to remove all previous screens from the stack
          // Navigator.pushReplacementNamed(context, '/login'); // or dashboard
          return null; // Indicate success
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Email varification Failed: ${apiResponse.message ?? "Unknown error"}');
          return 'Email varification Failed: ${apiResponse.message ?? "Unknown error"}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            '${response.body?['message'] ?? response.statusText}');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (error) {
      SnackBarHelper.showErrorSnackBar('Something went wrong: $error');
      return 'Error: $error';
    }
  }

  //? to get the login user detail from any where in the app
  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    User? userLogged = User.fromJson(userJson ?? {});
    return userLogged;
  }

  //? to logout the user
  logOutUser() {
    box.remove(USER_INFO_BOX);
    Get.offAll(LoginScreen());
  }

  //? to save login info after login
  Future<void> saveLoginInfo(User? loginUser, String token) async {
    if (loginUser != null) {
      await box.write(USER_INFO_BOX, loginUser.toJson());
      await box.write('auth_token', token); // Done inside saveLoginInfo()

      Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    } else {
      log('User is null, not saving');
    }
  }

  // Update user profile
  Future<String?> updateUserProfile(
      String itemId, String name, String? phone, String? gender) async {
    final String trimmedPhone = phone?.trim() ?? '';
    log("Phone input received: '$trimmedPhone'");

    // Validate phone number
    if (trimmedPhone.isEmpty || int.tryParse(trimmedPhone) == null) {
      log('Invalid phone number format!!');
      return 'Invalid phone number';
    }

    Map<String, dynamic> updatedData = {
      "name": name.trim(),
      "phone": trimmedPhone,
      // "gender": gender, // Uncomment if needed
    };

    try {
      final response = await service.updateItem(
        endpointUrl: 'users/update',
        itemId: itemId,
        itemData: updatedData,
        withAuth: true,
      );

      if (response.isOk) {
        final ApiResponse<Map<String, dynamic>> apiResponse =
            ApiResponse<Map<String, dynamic>>.fromJson(
                response.body, (json) => json as Map<String, dynamic>);

        if (apiResponse.success == true) {
          final updatedUserJson = apiResponse.data;

          // Check if user data exists
          if (updatedUserJson != null) {
            final updatedUser = User.fromJson(updatedUserJson);
            await updateLocalUserInfo(updatedUser); // Update local cache

            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            return null; // No error
          } else {
            return 'No user data returned.';
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Update failed: ${apiResponse.message}');
          return apiResponse.message;
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error: ${response.body?['message'] ?? response.statusText}');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      log('Exception while updating profile: $e');
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

// Save updated user info locally
  Future<void> updateLocalUserInfo(User updatedUser) async {
    if (updatedUser != null) {
      await box.write(USER_INFO_BOX, updatedUser.toJson());

      Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    } else {
      log('Updated user is null, not saving');
    }
  }
}
