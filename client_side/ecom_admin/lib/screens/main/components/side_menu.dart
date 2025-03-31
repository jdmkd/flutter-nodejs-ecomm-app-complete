import 'package:ecom_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isCollapsed ? 60 : 250, // Adjust width dynamically
      child: Stack(
        children: [
          Drawer(
            child: Column(
              children: [
                // DrawerHeader(
                //   child: Image.asset("assets/images/logo.png"),
                // ),
                SizedBox(height: 80),
                Align(
                  alignment: Alignment.center, // Center the text inside
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
                // press: () {
                //   context.mainScreenProvider.navigateToScreen('Dashboard');
                // },
                Expanded(
                  child: ListView(
                    children: [
                      DrawerListTile(
                        title: "Dashboard",
                        svgSrc: "assets/icons/menu_dashboard.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Dashboard');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Category",
                        svgSrc: "assets/icons/menu_tran.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Category');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Sub Category",
                        svgSrc: "assets/icons/menu_task.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('SubCategory');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Brands",
                        svgSrc: "assets/icons/menu_doc.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Brands');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Variant Type",
                        svgSrc: "assets/icons/menu_store.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('VariantType');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Variants",
                        svgSrc: "assets/icons/menu_notification.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Variants');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Orders",
                        svgSrc: "assets/icons/menu_profile.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Order');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Coupons",
                        svgSrc: "assets/icons/menu_setting.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Coupon');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Posters",
                        svgSrc: "assets/icons/menu_doc.svg",
                        press: () {
                          context.mainScreenProvider.navigateToScreen('Poster');
                        },
                        isCollapsed: isCollapsed,
                      ),
                      DrawerListTile(
                        title: "Notifications",
                        svgSrc: "assets/icons/menu_notification.svg",
                        press: () {
                          context.mainScreenProvider
                              .navigateToScreen('Notifications');
                        },
                        isCollapsed: isCollapsed,
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

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: isCollapsed
          ? null
          : Text(
              title,
              style: TextStyle(color: Colors.white54),
            ),
    );
  }
}
