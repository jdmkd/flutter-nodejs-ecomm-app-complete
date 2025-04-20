import 'dart:developer';

import 'package:ecom_client/screen/auth_screen/login_screen/login_screen.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/resend_otp_screen.dart';
import 'package:ecom_client/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/user_provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen(this.email, {super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // You can handle OTP verification logic here
      log("Entered OTP: $otp, type: ${otp.runtimeType}");

      log("email ==> ${widget.email}");
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final errorMessage =
          await userProvider.verifyOtp(widget.email, otp, context);

      // if (errorMessage == null) {
      //   // SnackBarHelper.showErrorSnackBar("xx :: ${errorMessage}");
      //   SnackBarHelper.showSuccessSnackBar("OTP verified successfully11.");
      // }
    } else {
      SnackBarHelper.showErrorSnackBar("Please enter all 4 digits of the OTP.");
    }
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("OTP Verification",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade500,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter the 4-digit code",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "We’ve sent a verification code to your registered email or phone number.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildOtpBox(index)),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Handle resend OTP logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ResendOtpScreen(widget.email)),
                    );
                  },
                  // child: const Text(
                  //   "Didn't get the code or it expired? Resend",
                  //   style: TextStyle(
                  //     color: Colors.green,
                  //     decoration: TextDecoration.underline,
                  //   ),
                  // ),
                  child: Stack(
                    clipBehavior: Clip.none, // Avoids clipping the underline
                    children: [
                      // Text
                      const Text(
                        "Didn't get the code or it expired? Resend",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Positioned Underline
                      Positioned(
                        bottom:
                            1, // Adjust this to control the gap between text and underline
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1, // Line thickness
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                TextButton(
                  onPressed: () {
                    // Handle resend OTP logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none, // Avoids clipping the underline
                    children: [
                      // Text
                      const Text(
                        "Continue with login?",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Positioned Underline
                      Positioned(
                        bottom:
                            1, // Adjust this to control the gap between text and underline
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1, // Line thickness
                          color: Colors.indigo,
                        ),
                      ),
                    ],
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
