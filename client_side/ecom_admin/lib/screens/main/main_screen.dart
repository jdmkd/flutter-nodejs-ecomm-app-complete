import 'provider/main_screen_provider.dart';
import '../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isCollapsed = true; // Track collapse state

  void toggleMenu() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainScreenProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Customize breakpoint as needed
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Content Area
          Positioned.fill(
            child: Consumer<MainScreenProvider>(
              builder: (context, provider, child) {
                return provider.selectedScreen;
              },
            ),
          ),

          // SideMenu with Stylish Glassmorphism Effect
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            left: isCollapsed ? -260 : 0, // Adjusted for better UX
            top: 0,
            bottom: 0,
            child: Container(
              width: 260, // Fixed width for menu
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4), // Glassmorphism effect
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: SideMenu(isCollapsed: isCollapsed, onToggle: toggleMenu),
            ),
          ),

          // Floating Menu Button
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: isMobile ? 60 : 60,
            left: isCollapsed
                ? isMobile
                      ? 17
                      : 55
                : 270,
            child: GestureDetector(
              onTap: toggleMenu,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isCollapsed ? Icons.menu : Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
