import 'dart:io'; // Needed for File class
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // Ensure you have this package added in pubspec.yaml

class EditMyProfileScreen extends StatefulWidget {
  const EditMyProfileScreen({super.key});

  @override
  _EditMyProfileScreenState createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNoController = TextEditingController();

  String? _profileImageUrl;

  // Image picker instance
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Assuming the user data is already set, populate fields with existing values.
    _nameController.text = 'John Doe';  // Replace with actual user data
    _emailController.text = 'johndoe@example.com';  // Replace with actual user data
    _phoneNoController.text = '91111';
    _profileImageUrl = 'assets/images/profile_pic.png';
  }

  // Pick an image from the gallery or camera
  // Future<void> _pickImage() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImageUrl = pickedFile.path; // Update the profile image URL with the picked image
  //     });
  //   }
  // }

  // Submit the form data
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process the updated profile data (e.g., update the database or user provider)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
        ),
        backgroundColor: Colors.blueAccent,  // Customize based on your app's theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Center(
                child: GestureDetector(
                  // onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:AssetImage('assets/images/profile_pic.png'),
                    // backgroundImage: _profileImageUrl != null
                    //     ? FileImage(File(_profileImageUrl!)) // Use FileImage for local image paths
                    //     : Image.asset('assets/images/profile_pic.png') as ImageProvider,  // Default image if none selected
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Form Section
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Input
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Phone number Input
                    TextFormField(
                      controller: _phoneNoController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Customize button color
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
