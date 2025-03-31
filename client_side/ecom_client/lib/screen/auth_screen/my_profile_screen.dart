import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_screen/provider/user_provider.dart';
import 'edit_my_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user details
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.getLoginUsr();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Profile Image Section
            CircleAvatar(
              radius: 60,
              backgroundImage: const AssetImage('assets/images/profile_pic.png'),
              backgroundColor: Colors.grey[300],
            ),

            const SizedBox(height: 16),

            // User Name
            Text(
              user?.name ?? 'User Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            // User Email
            Text(
              // user.email ?? 'Email not available',
              '-',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // User Information Card
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Phone Number Section
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text(
                          // user.phone ?? 'No phone number',
                          '9898989898',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditMyProfileScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
