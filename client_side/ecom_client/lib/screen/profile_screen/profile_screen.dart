import 'package:ecom_client/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../auth_screen/my_profile_screen/my_profile_screen.dart';
import '../auth_screen/login_screen/login_screen.dart';
import '../my_address_screen/my_address_screen.dart';
import '../my_order_screen/my_order_screen.dart';
import '../../utility/app_color.dart';
import '../../widget/navigation_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Explicitly enable system UI overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    // Ensure the status bar is visible
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // Adjust color as needed
    //   statusBarIconBrightness:
    //       Brightness.dark, // Use Brightness.light for light theme
    // ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Account",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "${context.userProvider.getLoginUsr()?.name}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(Icons.account_circle, 'My Profile',
                    const MyProfileScreen()),
                _buildProfileOption(
                    Icons.list, 'My Orders', const MyOrderScreen()),
                _buildProfileOption(
                    Icons.location_on, 'My Addresses', const MyAddressPage()),
                _buildProfileOption(Icons.settings, 'Settings', null),
                _buildProfileOption(Icons.help_outline, 'Help & Support', null),
                const SizedBox(height: 30),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, Widget? screen) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColor.darkOrange),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: () {
            if (screen != null) {
              Get.to(screen);
            }
          },
        ),
        const Divider(thickness: 1, height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          context.userProvider.logOutUser();
          Get.offAll(LoginScreen());
        },
        child: const Text('Logout',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
