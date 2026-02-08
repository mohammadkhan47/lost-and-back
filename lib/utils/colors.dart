import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00D9FF);
  static const Color accent = Color(0xFFFF6B6B);

  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFD63031);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF0984E3);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFBE76)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}