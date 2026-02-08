import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  String _navigationRoute = '/onboarding';

  bool get isLoading => _isLoading;
  String get navigationRoute => _navigationRoute;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Check if user is logged in
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      _navigationRoute = '/home';
    } else if (hasSeenOnboarding) {
      _navigationRoute = '/login';
    } else {
      _navigationRoute = '/onboarding';
    }

    _isLoading = false;
    notifyListeners();
  }
}