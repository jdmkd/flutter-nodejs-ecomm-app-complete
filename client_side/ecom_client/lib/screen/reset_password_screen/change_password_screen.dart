import 'package:ecotte/models/user.dart';
import 'package:ecotte/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecotte/utility/button.dart';
import 'package:ecotte/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;
  String itemId = "";

  // Button Style
  // final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  //   backgroundColor: Colors.blueAccent,
  //   padding: EdgeInsets.symmetric(vertical: 16),
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  // );

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

  // Reset Password Logic (mock)
  void _changePassword() async {
    final oldPassword = _oldPassController.text.trim();
    final newPassword = _newPassController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword != newPassword) {
      SnackBarHelper.showErrorSnackBar('Please fill out the fields correctly.');
      return;
    }

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final errorMessage = await userProvider.changeUserPassword(
      oldPassword,
      newPassword,
      itemId,
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      _oldPassController.clear();
      _newPassController.clear();
      _confirmPassController.clear();
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
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
                  'Change Your Password',
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

                // Old Password
                TextFormField(
                  controller: _oldPassController,
                  obscureText: true,
                  decoration: _buildInputDecoration(
                    'Old Password',
                    Icons.lock_outline,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your old password' : null,
                ),
                const SizedBox(height: 12),

                // New Password
                TextFormField(
                  controller: _newPassController,
                  obscureText: true,
                  decoration: _buildInputDecoration('New Password', Icons.lock),
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
                    'Confirm Password',
                    Icons.lock_reset,
                  ),
                  validator: (value) => value != _newPassController.text
                      ? 'Passwords do not match'
                      : null,
                ),

                const SizedBox(height: 24),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: buttonStyle,
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
