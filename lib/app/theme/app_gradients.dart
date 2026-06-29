import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized gradients used across the application.
///
/// Never create gradients directly inside widgets.
/// Always use AppGradients.

class AppGradients {
  AppGradients._();

  /// Main Brand Gradient
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryPink,
      AppColors.primaryOrange,
    ],
  );

  /// Soft Background Gradient
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFCFB),
      Color(0xFFFFF5EF),
    ],
  );

  /// Card Gradient
  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFFFFAF8),
    ],
  );

  /// FAB Gradient
  static const LinearGradient fab = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF4D8D),
      Color(0xFFFF8A3D),
    ],
  );

  /// Premium Glass Overlay
  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(40, 255, 255, 255),
      Color.fromARGB(12, 255, 255, 255),
    ],
  );
}