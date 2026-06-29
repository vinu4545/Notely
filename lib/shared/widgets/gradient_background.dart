import 'package:flutter/material.dart';

import '../../app/theme/app_gradients.dart';

/// Reusable background widget.
///
/// Every premium screen will use this.

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.background,
      ),
      child: child,
    );
  }
}