import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/user_provider.dart'; // Ensure correct import
import './login_screen.dart'; // Your Login Screen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _onRegisterPressed() async {
    final email = _emailController.text;
    final name = _fullNameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || email.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final errorMessage = await userProvider.register(
      name,
      email,
      password,
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      // Registration success, navigate to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 80, color: Colors.black),
              SizedBox(height: 10),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                title: 'Full Name',
                hint: 'Your Full Name',
                controller: _fullNameController,
                icon: Icons.person,
                obscureText: false,
              ),
              _buildTextField(
                title: 'Email',
                hint: 'youremail@email.com',
                controller: _emailController,
                icon: Icons.email,
                obscureText: false,
              ),
              _buildTextField(
                title: 'Password',
                hint: '**********',
                controller: _passwordController,
                icon: Icons.lock,
                obscureText: _obscurePassword,
                toggleObscure: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              _buildTextField(
                title: 'Confirm Password',
                hint: '**********',
                controller: _confirmPasswordController,
                icon: Icons.lock,
                obscureText: _obscureConfirmPassword,
                toggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onRegisterPressed,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          suffixIcon: toggleObscure != null
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: toggleObscure,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
