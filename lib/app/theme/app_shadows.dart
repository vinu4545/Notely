import 'package:flutter/material.dart';

/// Centralized shadow system for Notely.
///
/// Never create BoxShadow directly inside widgets.
/// Always use AppShadows.

class AppShadows {
  AppShadows._();

  /// Small Shadow
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium Shadow
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 18,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  /// Large Floating Shadow
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 30,
      spreadRadius: 0,
      offset: Offset(0, 16),
    ),
  ];
}