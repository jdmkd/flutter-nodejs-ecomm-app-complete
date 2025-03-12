import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/user.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../../utility/constants.dart';
import '../../../services/http_services.dart';
import '../login_screen.dart';


class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final box = GetStorage();

  UserProvider(this._dataProvider);

  Future<String?> login(String name, String password) async {
    try {
      Map<String, dynamic> credentials = {"name": name, "password": password};
      final response = await service.addItem(endpointUrl: 'users/login', itemData: credentials);
      log('Attempting Login with: $name - $password');

      log('Login API Response: ${response.body}');
      if (response.isOk) {
        final ApiResponse<User> apiResponse =
        ApiResponse<User>.fromJson(response.body, (json) => User.fromJson(json as Map<String, dynamic>));
        if (apiResponse.success ?? false) {
          User? user = apiResponse.data;
          saveLoginInfo(user);
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Login success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Login: ${apiResponse.message}');
          return 'Failed to Login';
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      Map<String, dynamic> user = {"name": name.toLowerCase(), "email": email, "password": password};
      final response = await service.addItem(endpointUrl: 'users/register', itemData: user);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Register Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Register: ${apiResponse.message}');
          return 'Failed to Register: ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      print(e);
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

  //? to get the login user detail from any whre the app
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
