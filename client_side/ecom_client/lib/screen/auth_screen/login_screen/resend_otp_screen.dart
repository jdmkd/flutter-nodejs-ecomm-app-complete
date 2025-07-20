import 'dart:developer';

import 'package:ecotte/screen/auth_screen/login_screen/otp_verification_screen.dart';
import 'package:ecotte/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecotte/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResendOtpScreen extends StatefulWidget {
  final String email;
  const ResendOtpScreen(this.email, {super.key});

  @override
  State<ResendOtpScreen> createState() => _ResendOtpScreenState();
}

class _ResendOtpScreenState extends State<ResendOtpScreen> {
  int _secondsRemaining = 30;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();

    log("this is email ==> ${widget.email}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resendOtp();
    });
  }

  bool _isCountdownRunning = false;

  void _startCountdown() {
    if (_isCountdownRunning) return;
    _isCountdownRunning = true;

    Future.doWhile(() async {
      if (_secondsRemaining == 0) {
        _isCountdownRunning = false;
        return false;
      }
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _secondsRemaining--;
      });
      return true;
    });
  }

  void _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final result = await userProvider.resendOtpAgainForVarifingRegisteredEmail(
      widget.email,
      context,
    );

    if (result['success']) {
      SnackBarHelper.showSuccessSnackBar("${result['message']}");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(widget.email),
        ),
        (route) => false,
      );
    } else {
      log("xxxxx ???? Please enter all 4 digits of the OTP.");
      SnackBarHelper.showErrorSnackBar("${result['message']}");
    }
    setState(() {
      _isResending = false;
      _secondsRemaining = 8;
    });

    _startCountdown();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("A new OTP has been sent.")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resend OTP", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Didn’t receive the code?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "We will sent a 4-digit code to your registered email. You can request a new code if you didn’t receive it.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Text(
                _secondsRemaining > 0
                    ? "Resend available in $_secondsRemaining seconds"
                    : "You can now resend the OTP",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Opacity(
                opacity: _secondsRemaining == 0 ? 1.0 : 0.6,
                child: ElevatedButton(
                  onPressed: _secondsRemaining == 0 && !_isResending
                      ? _resendOtp
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                  child: _isResending
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Resend Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
