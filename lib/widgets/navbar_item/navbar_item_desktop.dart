import 'package:flutter/material.dart';
import 'package:flutter_web/models/models.dart';
import 'package:provider_architecture/provider_architecture.dart';

class NavBarItemTabletDesktop extends ProviderWidget<ModelNavBarItem> {
  @override
  Widget build(BuildContext context, ModelNavBarItem model) {
    return Text(
      model.title,
      style: TextStyle(fontSize: 18),
    );
  }
}
