import 'package:flutter/material.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  int count =1;
  final List<Color> colors ;
  final TabBar tabBar;
  ColoredTabBar({super.key, 
      required this.colors, required this.count, required this.tabBar});




  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    color: count.isEven ? colors[0] : colors[1],
    child: tabBar,
  );
}