import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'product_cart_screen/cart_screen.dart';
import 'product_favorite_screen/favorite_screen.dart';
import 'product_list_screen/product_list_screen.dart';
import 'profile_screen/profile_screen.dart';
import '../../../utility/app_data.dart';
import '../../../widget/page_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Widget> screens = [
    ProductListScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Scaffold(
        // backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavyBar(
          itemCornerRadius: 10,
          selectedIndex: newIndex,
          // showElevation: true,
          backgroundColor: Colors.white,
          curve: Curves.easeInOut,
          items: AppData.bottomNavyBarItems.map(
            (item) {
              return BottomNavyBarItem(
                icon: Padding(
                  padding:
                      const EdgeInsets.all(0), // Space between icon and title

                  child: Icon(
                    item.icon.icon,
                    size: 28, // Fixed size for icon
                    color: newIndex == AppData.bottomNavyBarItems.indexOf(item)
                        ? item.activeColor // Active color when selected
                        : item
                            .inactiveColor, // Inactive color when not selected
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12, // Text size for the title
                    color: newIndex == AppData.bottomNavyBarItems.indexOf(item)
                        ? item.activeColor
                        : item.inactiveColor,
                  ),
                ),
                activeColor: item.activeColor,
                inactiveColor: item.inactiveColor,
              );
            },
          ).toList(),
          onItemSelected: (currentIndex) {
            setState(() {
              newIndex = currentIndex;
            });
          },
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: HomeScreen.screens[newIndex],
        ),
      ),
    );
  }
}
