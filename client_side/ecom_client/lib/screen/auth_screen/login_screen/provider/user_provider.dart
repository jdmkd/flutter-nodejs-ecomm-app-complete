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
      log("An error occurred: $e");
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
          // Use Get.offAll to remove all previous screens from the stack
          Get.offAll(LoginScreen());

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

  // resend New OTP for unvarified Registered Email
  Future<Map<String, dynamic>> resendOtpAgainForVarifingRegisteredEmail(
      String email, BuildContext context) async {
    final updatedData = {"email": email};

    log("resend udateData  => ${updatedData}");

    try {
      final response = await service.addItem(
        endpointUrl: 'users/email/resend/verify-otp',
        itemData: updatedData,
        // withAuth: true,
      );
      log("OTP resend response1 => $response");
      log("OTP resend response.body => ${response.body}");
      log("OTP resend response.statusCode => ${response.statusCode}");

      final resData = response.body;

      if (resData['success'] == true) {
        log("OTP sent successfully to => $email");
        return {
          'success': true,
          'message': resData['message'] ?? 'OTP sent successfully.',
        };
      } else {
        return {
          'success': false,
          'message': resData['message'] ?? 'Failed to resend OTP.',
        };
      }
    } catch (e) {
      log("OTP send error => $e");
      return {
        'success': false,
        'message': e.toString(),
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

    // Validate phone number
    if (trimmedPhone.isEmpty || int.tryParse(trimmedPhone) == null) {
      return 'Invalid phone number';
    }

    if (dateOfBirth.isNotEmpty) {
      try {
        DateTime dob = DateFormat('yyyy-MM-dd').parseStrict(dateOfBirth);
        DateTime today = DateTime.now();

        if (dob.isAfter(today)) {
          return 'XX Date of Birth cannot be in the future';
        }

        int age = today.year - dob.year;

        if (dob.month > today.month ||
            (dob.month == today.month && dob.day > today.day)) {
          age--;
        }

        if (age < 16) {
          return 'You must be at least 16 years old';
        }
      } catch (e) {
        return 'Please enter a valid Date of Birth ::: $e';
      }
    } else {
      log("DOB not provided, skipping DOB update.");
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
      // log("updatedUser => ${updatedUser}");
      // log("USER_INFO_BOX ==> ${box.read(USER_INFO_BOX)}");
    } else {
      log('Updated user is null, not saving');
    }
  }

  Future<String?> changeUserPassword(
      String oldPassword, String newPassword, String itemId) async {
    log("oldPassword => ${oldPassword}");
    log("newPassword => ${newPassword}");

    Map<String, dynamic> updatedData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    log("updatedData  => ${updatedData}");
    try {
      final response = await service.updateItem(
        endpointUrl: 'users/password/change',
        itemId: itemId,
        itemData: updatedData,
        withAuth: true,
      );

      log("response.statusCode => ${response.statusCode}");
      log("response.isOk => ${response.isOk}");
      log("response.body => ${response.body}");

      if (response.isOk) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.body, (json) => json as Map<String, dynamic>);

        log("apiResponse1 ==> $apiResponse");
        log("apiResponse.data ==> ${apiResponse.data}");
        log("apiResponse.success ==> ${apiResponse.success}");
        log("apiResponse.message ==> ${apiResponse.message}");

        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Update failed: ${apiResponse.message}');
          return apiResponse.message;
        }
      } else {
        final errorMsg =
            response.body?['message'] ?? response.statusText ?? 'Unknown error';
        SnackBarHelper.showErrorSnackBar('Error: $errorMsg');
        return errorMsg;
      }
    } catch (e) {
      log('Exception while updating profile: $e');
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  // reset Password Otp Send
  Future<String?> resetPasswordOtpSend(String email) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      // "itemId": itemId,
    };

    log("updatedData  => ${updatedData}");

    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/send-otp',
        itemData: updatedData,
        // withAuth: true,
      );
      log("OTP send response1 => $response");
      log("OTP send response.body => ${response.body}");
      log("OTP send response.statusCode => ${response.statusCode}");
      final resData = response.body;
      if (resData['success'] == true) {
        return null; // null means success
      } else {
        return resData['message'] ?? 'Unknown error';
      }
    } catch (e) {
      log("OTP send error => $e");
      return e.toString(); // Return error string
    }
  }

  Future<String?> resetPasswordWithOtpOnly(String email, String otp) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      "otp": otp,
    };

    log("Verifying OTP with data1 => $updatedData");

    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/verify-otp-only',
        itemData: updatedData,
      );

      log("OTP verify response2 => $response");
      log("OTP send response2 => $response");
      log("OTP send response.body2 => ${response.body}");
      log("OTP send response.statusCode2 => ${response.statusCode}");
      final resData = response.body;
      if (resData['success'] == true) {
        return null; // success
      } else {
        return resData['message'] ?? "Something went wrong";
      }
    } catch (e) {
      log("OTP verify error => $e");
      return e.toString(); // Return error string
    }
  }

  Future<String?> resetPasswordWithOtp(
      String email, String otp, String newPassword) async {
    Map<String, dynamic> updatedData = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    };

    log("Verifying OTP with data2 => $updatedData");

    try {
      final response = await service.addItem(
        endpointUrl: 'users/password/reset/verify-otp',
        itemData: updatedData,
      );

      final resData = response.body;
      log("response1x ==> ${response.body}");
      if (response.isOk) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.body, (json) => json as Map<String, dynamic>);

        log("apiResponse1 ==> $apiResponse");
        log("apiResponse.data1 ==> ${apiResponse.data}");
        log("apiResponse.success1 ==> ${apiResponse.success}");
        log("apiResponse.message1 ==> ${apiResponse.message}");

        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Update failed: ${apiResponse.message}');
          return apiResponse.message;
        }
      } else {
        final errorMsg =
            response.body?['message'] ?? response.statusText ?? 'Unknown error';
        SnackBarHelper.showErrorSnackBar('Error: $errorMsg');
        return errorMsg;
      }
    } catch (e) {
      log("OTP verify error => $e");
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }
}
