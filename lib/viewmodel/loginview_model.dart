import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import '../services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  // Private variables (State)
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  bool _obscurePassword = true;

  // Constructor - Dependency Injection
  LoginViewModel(this._authService);

  // Getters (Read-only access)
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get obscurePassword => _obscurePassword;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sign In Method
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );

      if (userCredential.user != null) {
        // Get user data from Firestore or create from Firebase Auth User
        _currentUser = await _authService.getUserData(userCredential.user!.uid);

        // If user data doesn't exist in Firestore, create from Firebase Auth
        if (_currentUser == null) {
          _currentUser = UserModel.fromFirebaseAuthUser(userCredential.user!);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Error message handler
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Get current user
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;
}