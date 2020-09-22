import 'package:flutter/material.dart';
import 'package:boke/routing/route_names.dart';
import 'navbar_logo.dart';

class NavigationBarMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          NavBarLogo(
            navigationPath: RouteHome,
          )
        ],
      ),
    );
  }
}
