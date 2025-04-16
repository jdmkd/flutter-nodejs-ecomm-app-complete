import 'dart:developer';

import 'package:ecom_client/models/order.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecom_client/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMyProfileScreen extends StatefulWidget {
  const EditMyProfileScreen({super.key});

  @override
  _EditMyProfileScreenState createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'Male';
  String? _profileImagePath = 'assets/images/profile_pic.png';
  String itemId = "";

  final List<String> _genders = ['Male', 'Female', 'Other'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.getLoginUsr();

      setState(() {
        itemId = user?.sId ?? '';
        // user

        _nameController.text = user?.name ?? '';
        _emailController.text = user?.email ?? '';
        _phoneController.text = user?.phone ?? '';
        _addressController.text = '';
        // _profileImageUrl = 'assets/images/profile_pic.png';
      });
    });
  }

  void _submit() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final gender = _selectedGender;

    if (name.isEmpty || name.length < 3) {
      SnackBarHelper.showErrorSnackBar(
          "Please enter a valid name (min 3 characters)");
      return;
    }

    if (phone.isEmpty || phone.length < 10 || int.tryParse(phone) == null) {
      SnackBarHelper.showErrorSnackBar(
          "Please enter a valid 10-digit mobile number");
      return;
    }

    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final errorMessage = await userProvider.updateUserProfile(
      itemId,
      name,
      phone,
      gender,
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      Navigator.pop(context, true);
    } else {
      SnackBarHelper.showErrorSnackBar("Error: $errorMessage");
    }
  }

  void _navigateToResetPassword() {
    Navigator.pushNamed(context, '/reset-password'); // Create this route
  }

  void _changeProfilePhoto() {
    // Logic to change image
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change photo tapped!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile image with edit icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(_profileImagePath!),
                    backgroundColor: Colors.grey[300],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    // style: BorderStyle
                    onPressed: _changeProfilePhoto,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Full Name', Icons.person),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                readOnly: true,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('Email Address', Icons.email)
                    .copyWith(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('Phone Number', Icons.phone),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: _buildInputDecoration('Address', Icons.home),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 16),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _buildInputDecoration('Gender', Icons.person_3),
                items: _genders.map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedGender = value!);
                },
              ),
              const SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.green),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Reset Password link
              GestureDetector(
                onTap: _navigateToResetPassword,
                child: const Text(
                  'Forgot Password? Reset here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
