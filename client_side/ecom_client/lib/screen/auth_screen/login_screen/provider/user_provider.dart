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
          Map<String, dynamic>? userData =
              apiResponse.data?['user']; // Extract user object
          if (userData != null) {
            User user = User.fromJson(userData); // Create a User object
            saveLoginInfo(user); // Save correct user info
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
            'Error: ${response.body?['message'] ?? response.statusText}');
        return 'Error: ${response.body?['message'] ?? response.statusText}';
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
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Register: ${apiResponse.message ?? "Unknown error"}');
          return 'Failed to Register: ${apiResponse.message ?? "Unknown error"}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error 1${response.body?['message'] ?? response.statusText}');
        return 'Error 2${response.body?['message'] ?? response.statusText}';
      }
    } catch (e, stackTrace) {
      log("Registration error: $e");
      log("Stack Trace: $stackTrace");

      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  //? to save login info after login
  Future<void> saveLoginInfo(User? loginUser) async {
    if (loginUser != null) {
      await box.write(USER_INFO_BOX, loginUser.toJson());
      Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
      log('User saved: ${box.read(USER_INFO_BOX)}'); // Debug log
    } else {
      log('User is null, not saving');
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
}
