import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isCollapsed,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 24,
      ),
      title: isCollapsed
          ? null // Hide text when collapsed
          : Text(title, style: TextStyle(color: Colors.white54)),
    );
  }
}
