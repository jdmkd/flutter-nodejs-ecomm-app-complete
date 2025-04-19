import 'package:ecom_client/screen/auth_screen/login_screen/login_screen.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecom_client/screen/auth_screen/my_profile_screen/my_profile_screen.dart';
import 'package:ecom_client/screen/auth_screen/reset_password_screen/change_password_screen.dart';
import 'package:ecom_client/screen/auth_screen/reset_password_screen/reset_password_screen.dart';
import 'package:ecom_client/utility/button.dart';
import 'package:ecom_client/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordWithOtpScreen extends StatefulWidget {
  const ResetPasswordWithOtpScreen({super.key});

  @override
  State<ResetPasswordWithOtpScreen> createState() =>
      _ResetPasswordWithOtpScreenState();
}

class _ResetPasswordWithOtpScreenState
    extends State<ResetPasswordWithOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  bool _isLoading = false;
  String itemId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.getLoginUsr();
      setState(() {
        itemId = user?.sId ?? '';
      });
    });
  }

  void _sendOtp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      SnackBarHelper.showErrorSnackBar("Enter a valid email");
      return;
    }

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final errorMessage =
        await userProvider.resetPasswordOtpSend(_emailController.text.trim());

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      setState(() => _otpSent = true);
      SnackBarHelper.showSuccessSnackBar(
          "OTP sent to ${_emailController.text}");
    } else {
      SnackBarHelper.showErrorSnackBar(errorMessage);
    }
  }

  void _verifyOtp() async {
    if (_otpController.text.length == 4) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final errorMessage = await userProvider.resetPasswordWithOtpOnly(
        _emailController.text.trim(),
        _otpController.text.trim(),
      );

      if (errorMessage == null) {
        setState(() => _otpVerified = true);
        SnackBarHelper.showSuccessSnackBar("OTP Verified!");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                  _emailController.text.trim(), _otpController.text.trim())),
        );
      } else {
        SnackBarHelper.showErrorSnackBar("xxx1 : ${errorMessage}");
      }
    } else {
      SnackBarHelper.showErrorSnackBar("Enter a valid 4-digit OTP");
    }
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      //// Optional: call API to change password (new screen like ChangePasswordScreen)
      SnackBarHelper.showSuccessSnackBar("Password successfully reset!");
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void _navigateToChangePassword() {
    // Navigator.pushNamed(context, '/reset-password'); // Create this route
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (itemId.isNotEmpty) {
              //// User is logged in → go to EditProfileScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyProfileScreen()),
              );
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset, size: 80, color: Colors.blueAccent),
                  SizedBox(height: 10),
                  Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter your email address below, and we will send you a varification code to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  if (!_otpSent)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _sendOtp,
                          style: buttonStyle,
                          child: const Text("Send OTP")),
                    ),
                  if (_otpSent && !_otpVerified) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _otpController,
                      decoration:
                          _buildInputDecoration('Enter OTP', Icons.lock_clock),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: buttonStyle,
                          child: const Text("Verify OTP")),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (itemId.isNotEmpty)
                    GestureDetector(
                      onTap: _navigateToChangePassword,
                      child: const Text(
                        'Change Password? click here',
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
