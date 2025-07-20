import 'package:ecotte_admin/screens/main/provider/main_screen_provider.dart';
import 'package:ecotte_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utility/constants.dart';

class SideMenu extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;

  const SideMenu({
    Key? key,
    required this.isCollapsed,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentKey = context.mainScreenProvider.currentScreenKey;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: isCollapsed ? 60 : 250,
      child: Stack(
        children: [
          Drawer(
            child: Column(
              children: [
                // DrawerHeader(
                //   child: Image.asset("assets/images/logo.png"),
                // ),
                SizedBox(height: 70),
                Align(
                  alignment: Alignment.bottomCenter, // Center the text inside
                  child: Text(
                    "Welcome Admin",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: [
                      DrawerListTile(
                        title: "Dashboard",
                        svgSrc: "assets/icons/menu_dashboard.svg",
                        press: () {
                          Provider.of<MainScreenProvider>(context,
                                  listen: false)
                              .navigateToScreen('Dashboard');

                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Dashboard',
                      ),
                      DrawerListTile(
                        title: "Category",
                        svgSrc: "assets/icons/menu_tran.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Category');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Category',
                      ),
                      DrawerListTile(
                        title: "Sub Category",
                        svgSrc: "assets/icons/menu_task.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('SubCategory');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'SubCategory',
                      ),
                      DrawerListTile(
                        title: "Brands",
                        svgSrc: "assets/icons/menu_doc.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Brands');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Brands',
                      ),
                      DrawerListTile(
                        title: "Variant Type",
                        svgSrc: "assets/icons/menu_store.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('VariantType');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'VariantType',
                      ),
                      DrawerListTile(
                        title: "Variants",
                        svgSrc: "assets/icons/menu_notification.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Variants');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Variants',
                      ),
                      DrawerListTile(
                        title: "Orders",
                        svgSrc: "assets/icons/menu_profile.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Order');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Order',
                      ),
                      DrawerListTile(
                        title: "Coupons",
                        svgSrc: "assets/icons/menu_setting.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Coupon');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Coupon',
                      ),
                      DrawerListTile(
                        title: "Posters",
                        svgSrc: "assets/icons/menu_doc.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Poster');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Poster',
                      ),
                      DrawerListTile(
                        title: "Notifications",
                        svgSrc: "assets/icons/menu_notification.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Notifications');
                          onToggle();
                        },
                        isCollapsed: isCollapsed,
                        isSelected: currentKey == 'Notifications',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 20,
          //   left: isCollapsed ? 10 : 210,
          //   child: IconButton(
          //     icon: Icon(Icons.menu, color: Colors.white),
          //     onPressed: onToggle,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final VoidCallback press;
  final bool isCollapsed;
  final bool isSelected;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isCollapsed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      tileColor:
          isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.white : Colors.white54,
          BlendMode.srcIn,
        ),
        height: 16,
      ),
      title: isCollapsed
          ? null
          : Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
    );
  }
}
