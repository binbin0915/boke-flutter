import 'package:flutter/material.dart';
import 'package:flutter_web/locator.dart';
import 'package:flutter_web/services/services.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavBarLogo extends StatelessWidget {
  final String navigationPath;

  NavBarLogo({this.navigationPath});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        double sizeWH = sizeInfo.isMobile ? 36 : 60;
        double radius = sizeInfo.isMobile ? 18 : 4;

        return GestureDetector(
          onTap: () {
            locator<NavigationService>().navigateTo(navigationPath);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              height: sizeWH,
              width: sizeWH,
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ),
        );
      },
    );
  }
}
