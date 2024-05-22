import 'package:flutter/material.dart';
import 'colors.dart';

class AppDecoration {
  // Gradient decorations
  static Gradient get primaryGradient => const LinearGradient(colors: [
        AppColor.primaryLight,
        Colors.red,
      ]);
}
