import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

class GlassCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.lg,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((.15 * 255).round()),
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: Colors.white.withAlpha((.25 * 255).round()),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
