import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

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

      // log('Attempting Login with: $email');

      if (response.isOk) {
        final ApiResponse<Map<String, dynamic>> apiResponse =
            ApiResponse<Map<String, dynamic>>.fromJson(
                response.body, (json) => json as Map<String, dynamic>);
        if (apiResponse.success ?? false) {
          Map<String, dynamic>? userData = apiResponse.data?['user'];
          String? token = apiResponse.data?['token'];

          if (userData != null && token != null) {
            User user = User.fromJson(userData);
            await saveLoginInfo(user, token);

            SnackBarHelper.showSuccessSnackBar(
              apiResponse.message.isNotEmpty
                  ? apiResponse.message
                  : 'Login successful. Welcome back!',
            );
            // log('Login success: ${user.toJson()}');
            return null;
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Unable to process your login. Please try again.');
            return 'Unable to process your login. Please try again.';
          }
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Login failed. Please check your credentials and try again.');
          return 'Login failed. Please check your credentials and try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Login failed. Please check your credentials and try again.');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      // log("An error occurred: $e");
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
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

      if (response == null || response.body == null) {
        SnackBarHelper.showErrorSnackBar(
            'Unable to connect to the server. Please try again later.');
        return 'Unable to connect to the server. Please try again later.';
      }

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Registration successful. Please check your email for verification.');
          // log('Register Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'A:: Registration failed. Please try again.');
          return apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'B:: Registration failed. Please try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            '${response.body?['message'] ?? response.statusText}');
        return '${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      // log("Registration error: $e");
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<String?> verifyOtp(
      String email, String otp, BuildContext context) async {
    try {
      Map<String, dynamic> user = {"email": email, "otp": otp, "purpose": 0};

      // purpose=0 for registraion purpose=1 for the forgot password
      final response = await service.addItem(
          endpointUrl: 'users/verify-otp', itemData: user);

      if (response == null || response.body == null) {
        SnackBarHelper.showErrorSnackBar(
            'Unable to connect to the server. Please try again later.');
        return 'Unable to connect to the server. Please try again later.';
      }

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Verification successful.');
          Get.offAll(LoginScreen());
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Verification failed. Please try again.');
          return apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Verification failed. Please try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Verification failed. Please try again.');
        return 'Verification failed. Please try again.';
      }
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  // resend New OTP for unvarified Registered Email
  Future<Map<String, dynamic>> resendOtpAgainForVarifingRegisteredEmail(
      String email, BuildContext context) async {
    final updatedData = {"email": email};
    try {
      final response = await service.addItem(
        endpointUrl: 'users/email/resend/verify-otp',
        itemData: updatedData,
        // withAuth: true,
      );
      final resData = response.body;

      if (resData['success'] == true) {
        return {
          'success': true,
          'message':
              resData['message'] ?? 'A new OTP has been sent to your email.',
        };
      } else {
        return {
          'success': false,
          'message':
              resData['message'] ?? 'Failed to resend OTP. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again later.',
      };
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
  Future<String?> updateUserProfile(String itemId, String name, String? phone,
      String? gender, String dateOfBirth, String currentAddress) async {
    final String trimmedPhone = phone?.trim() ?? '';

    if (trimmedPhone.isEmpty || int.tryParse(trimmedPhone) == null) {
      return 'Please enter a valid phone number.';
    }

    if (dateOfBirth.isNotEmpty) {
      try {
        DateTime dob = DateFormat('yyyy-MM-dd').parseStrict(dateOfBirth);
        DateTime today = DateTime.now();

        if (dob.isAfter(today)) {
          return 'Date of Birth cannot be in the future.';
        }
        int age = today.year - dob.year;

        if (dob.month > today.month ||
            (dob.month == today.month && dob.day > today.day)) {
          age--;
        }
        if (age < 16) {
          return 'You must be at least 16 years old.';
        }
      } catch (e) {
        return 'Please enter a valid Date of Birth.';
      }
    }

    Map<String, dynamic> updatedData = {
      "name": name.trim(),
      "phone": trimmedPhone,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "currentAddress": currentAddress,
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
          if (updatedUserJson != null) {
            final updatedUser = User.fromJson(updatedUserJson);
            await updateLocalUserInfo(updatedUser);
            SnackBarHelper.showSuccessSnackBar(apiResponse.message.isNotEmpty
                ? apiResponse.message
                : 'Profile updated successfully.');
            return null;
          } else {
            return 'Profile updated, but no user data returned.';
          }
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Profile update failed. Please try again.');
          return apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Profile update failed. Please try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Profile update failed. Please try again.');
        return 'Profile update failed. Please try again.';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

// Save updated user info locally
  Future<void> updateLocalUserInfo(User updatedUser) async {
    if (updatedUser != null) {
      await box.write(USER_INFO_BOX, updatedUser.toJson());
      Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
      // log("updatedUser => ${updatedUser}");
      // log("USER_INFO_BOX ==> ${box.read(USER_INFO_BOX)}");
    } else {
      log('Updated user is null, not saving');
    }
  }

  Future<String?> changeUserPassword(
      String oldPassword, String newPassword, String itemId) async {
    Map<String, dynamic> updatedData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    try {
      final response = await service.updateItem(
        endpointUrl: 'users/password/change',
        itemId: itemId,
        itemData: updatedData,
        withAuth: true,
      );
      if (response.isOk) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.body, (json) => json as Map<String, dynamic>);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password changed successfully.');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password change failed. Please try again.');
          return apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password change failed. Please try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Password change failed. Please try again.');
        return 'Password change failed. Please try again.';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  // reset Password Otp Send
  Future<String?> resetPasswordOtpSend(String email) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      // "itemId": itemId,
    };
    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/send-otp',
        itemData: updatedData,
        // withAuth: true,
      );
      final resData = response.body;
      if (resData['success'] == true) {
        return null;
      } else {
        return resData['message'] ?? 'Failed to send OTP. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<String?> resetPasswordWithOtpOnly(String email, String otp) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      "otp": otp,
    };
    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/verify-otp-only',
        itemData: updatedData,
      );
      final resData = response.body;
      if (resData['success'] == true) {
        return null;
      } else {
        return resData['message'] ??
            'OTP verification failed. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<String?> resetPasswordWithOtp(
      String email, String otp, String newPassword) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    };
    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/verify-otp',
        itemData: updatedData,
      );
      if (response.isOk) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.body, (json) => json as Map<String, dynamic>);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password reset successfully.');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password reset failed. Please try again.');
          return apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Password reset failed. Please try again.';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Password reset failed. Please try again.');
        return 'Password reset failed. Please try again.';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
      return 'An unexpected error occurred. Please try again later.';
    }
  }
}
