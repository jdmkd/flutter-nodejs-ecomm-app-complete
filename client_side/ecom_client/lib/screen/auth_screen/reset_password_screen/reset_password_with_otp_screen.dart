import 'package:ecom_client/screen/auth_screen/login_screen/provider/user_provider.dart';
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ResetPasswordMainScreen(),
        //   ),
        // );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  ResetPasswordScreen(_otpController.text.trim())),
          (route) => false,
        );
      } else {
        SnackBarHelper.showErrorSnackBar(errorMessage);
      }
    } else {
      SnackBarHelper.showErrorSnackBar("Enter a valid 4-digit OTP");
    }
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Optional: call API to change password (new screen like ChangePasswordScreen)
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
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                GestureDetector(
                  onTap: _navigateToChangePassword,
                  child: const Text(
                    'Change Password? Reset here',
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
    );
  }
}
