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
    return PopScope(
      canPop: false, // prevents back navigation
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE0E0E0), // Subtle grey
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: newIndex,
              selectedItemColor: Colors.indigoAccent[400],
              unselectedItemColor: Color(0xFFBDBDBD),
              // iconSize: 26, // Smaller or larger for height
              // selectedFontSize: 15, // Adjust for label size
              // unselectedFontSize: 13,
              onTap: (currentIndex) {
                setState(() {
                  newIndex = currentIndex;
                });
              },
              items: AppData.bottomNavyBarItems.map((item) {
                return BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                );
              }).toList(),
            ),
          ),
          body: PageTransitionSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder:
                (
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
      ),
    );
  }
}
