import 'package:ecom_client/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../widget/custom_search_bar.dart';
import '../../auth_screen/my_profile_screen/my_profile_screen.dart';
import '../../profile_screen/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // Removes shadow for a clean look
      automaticallyImplyLeading: false, // Removes default back button
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            // Search Bar (Expanded to take available space)
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomSearchBar(
                        controller: TextEditingController(),
                        onChanged: (val) {
                          context.dataProvider.filterProducts(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Profile Icon Button
            IconButton(
              icon: const Icon(Icons.account_circle, size: 40, color: Colors.black54),
              onPressed: () {
                // Navigate to Profile Screen
                Navigator.of(context).push(
                  // MaterialPageRoute(builder: (context) => MyProfileScreen()),
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
