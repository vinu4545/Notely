import 'package:flutter/material.dart';

import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_radius.dart';

class AnimatedFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const AnimatedFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      elevation: 16,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.pill,
      ),
      label: Ink(
        decoration: const BoxDecoration(
          gradient: AppGradients.fab,
          borderRadius: AppRadius.pill,
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
