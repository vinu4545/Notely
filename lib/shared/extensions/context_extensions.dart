import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isDesktop => MediaQuery.of(this).size.width >= 900;

  bool get isTablet => MediaQuery.of(this).size.width >= 600 && !isDesktop;

  double get horizontalPadding => isDesktop ? 40 : 20;

  Size get screenSize => MediaQuery.of(this).size;
}
