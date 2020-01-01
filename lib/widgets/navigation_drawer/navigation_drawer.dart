import 'package:flutter/material.dart';
import 'package:flutter_web/widgets/nav_drawer/drawer_item.dart';
import 'package:flutter_web/widgets/navigation_drawer/navigation_drawer_header.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)]),
      child: Column(
        children: <Widget>[
          NavigationDrawerHeader(),
          DrawerItem(title: '文章', icon: Icons.book),
          DrawerItem(
            title: '关于',
            icon: Icons.help,
          )
        ],
      ),
    );
  }
}
