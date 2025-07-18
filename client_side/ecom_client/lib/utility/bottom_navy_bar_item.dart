import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Color, Colors, Icon;

@immutable
class BottomNavyBarItem {
  final String title;
  final Icon icon;
  final Color activeColor;
  final Color inactiveColor; // Updated field name

  const BottomNavyBarItem(
    this.title,
    this.icon,
    this.activeColor, [
    this.inactiveColor = Colors.grey, // Updated field name
  ]);
}
