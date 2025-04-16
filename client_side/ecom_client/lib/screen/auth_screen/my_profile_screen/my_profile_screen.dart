import 'package:ecom_client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_screen/provider/user_provider.dart';
import '../edit_my_profile_screen/edit_my_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.getLoginUsr();
    setState(() {}); // Refresh screen
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container(
            //   height: 100,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Colors.indigo.shade400, Colors.indigo.shade600],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            const AssetImage('assets/images/profile_pic.png'),
                        backgroundColor: Colors.white,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.indigo,
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name and Email
                  Text(
                    user?.name ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        buildInfoTile(Icons.phone, 'Phone Number',
                            user?.phone ?? '9898989898'),
                        const Divider(),
                        buildInfoTile(Icons.cake_outlined, 'Date of Birth',
                            '01 Jan 2000'),
                        const Divider(),
                        buildInfoTile(Icons.location_on_outlined, 'Location',
                            'Ahmedabad, Gujarat'),
                        const Divider(),
                        buildInfoTile(Icons.badge_outlined, 'Profession',
                            'Software Developer'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditMyProfileScreen(),
                          ),
                        );

                        if (result == true) {
                          fetchUserData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo.shade500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
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
    );
  }

  Widget buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo.shade400, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
