import '../../core/data/data_provider.dart';
import '../tracking_screen/tracking_screen.dart';
import '../../utility/app_color.dart';
import '../../utility/extensions.dart';
import '../../utility/utility_extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widget/order_tile.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming 'getLoginUsr' returns the current logged-in user.
    final user = context.userProvider.getLoginUsr();

    // Fetch orders for the logged-in user
    context.dataProvider.getAllOrderByUser(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      const AssetImage('assets/images/profile_pic.png'),
                  backgroundColor: Colors.grey[300],
                ),

                SizedBox(height: 16),

                // User's Name
                Text(
                  user?.name ?? 'Your Name', // Replace with actual user's name
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // User's Email
                // Text(
                //   // user?.email ?? 'johndoe@example.com', // Replace with actual user's email
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.grey[600],
                //   ),
                // ),
                SizedBox(height: 16),
              ],
            ),
          ),

          // Order List Section
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, provider, child) {
                if (context.dataProvider.orders.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: context.dataProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = context.dataProvider.orders[index];
                    return OrderTile(
                      paymentMethod: order.paymentMethod ?? '',
                      items:
                          // '${(order.items.safeElementAt(0)?.productName ?? '')} & ${order.items!.length - 1} Items',
                          '${(order.items.safeElementAt(0)?.productName ?? '')}',
                      date: order.orderDate ?? '',
                      status: order.orderStatus ?? 'pending',
                      onTap: () {
                        if (order.orderStatus == 'shipped') {
                          Get.to(TrackingScreen(url: order.trackingUrl ?? ''));
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
