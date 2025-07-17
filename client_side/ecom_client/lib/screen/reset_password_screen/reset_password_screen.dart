import 'dart:developer';

import 'package:ecom_client/models/user.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/login_screen.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecom_client/screen/my_profile_screen/my_profile_screen.dart';
import 'package:ecom_client/screen/reset_password_screen/reset_password_with_otp_screen.dart';
import 'package:ecom_client/utility/button.dart';
import 'package:ecom_client/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen(this.email, this.otp, {super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;
  String itemId = "";
  String email = "";
  // String otp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.getLoginUsr();

      setState(() {
        itemId = user?.sId ?? '';
        email = user?.email ?? widget.email;
      });
    });
  }

  // Reset Password Logic (mock)
  void _resetPassword() async {
    final newPassword = _newPassController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    if (newPassword.isEmpty || confirmPassword != newPassword) {
      SnackBarHelper.showErrorSnackBar('Please fill out the fields correctly.');
      return;
    }

    setState(() => _isLoading = true);
    log("Resetting password for ==>>>>>> $email");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final errorMessage =
        await userProvider.resetPasswordWithOtp(email, widget.otp, newPassword);

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      _newPassController.clear();
      _confirmPassController.clear();

      if (itemId.isNotEmpty) {
        Navigator.of(context).pop();
      } else {
        // Not logged-in user: go to login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } else {
      log("errorMessage :::: $errorMessage");
      SnackBarHelper.showErrorSnackBar(errorMessage);
    }
  }

  void _navigateToResendEmailScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ResetPasswordWithOtpScreen()),
    );
    // Navigator.of(context).pop();
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevents back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reset Password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (itemId.isNotEmpty) {
                Navigator.of(context).pop();
              } else {
                //// User is not logged in → go to LoginScreen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 80, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    'Reset Your Password',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300], // Light gray color for the line
                    thickness: 1.2, // Thickness of the line
                    indent: 40, // Indentation on left side
                    endIndent: 40, // Indentation on right side
                  ),
                  Text(
                    'Secure your account by creating a new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // New Password
                  TextFormField(
                    controller: _newPassController,
                    obscureText: true,
                    decoration:
                        _buildInputDecoration('New Password', Icons.lock),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter a new password';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Confirm New Password
                  TextFormField(
                    controller: _confirmPassController,
                    obscureText: true,
                    decoration: _buildInputDecoration(
                        'Confirm Password', Icons.lock_reset),
                    validator: (value) => value != _newPassController.text
                        ? 'Passwords do not match'
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: buttonStyle,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _navigateToResendEmailScreen,
                    child: const Text(
                      'Resend email? click here',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueAccent,
                        decorationThickness: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
