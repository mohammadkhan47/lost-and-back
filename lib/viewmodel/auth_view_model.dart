// // lib/viewmodels/auth_viewmodel.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../model/user_model.dart';
// import '../services/auth_services.dart';
//
// class AuthViewModel extends ChangeNotifier {
//   final AuthService _authService;
//
//   bool _isLoading = false;
//   String? _errorMessage;
//   UserModel? _currentUser;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   AuthViewModel(this._authService) {
//     _initializeUser();
//   }
//
//   // Getters
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   UserModel? get currentUser => _currentUser;
//   bool get obscurePassword => _obscurePassword;
//   bool get obscureConfirmPassword => _obscureConfirmPassword;
//
//   void _initializeUser() async {
//     final user = _authService.currentUser;
//     if (user != null) {
//       _currentUser = await _authService.getUserData(user.uid);
//       notifyListeners();
//     }
//   }
//
//   void togglePasswordVisibility() {
//     _obscurePassword = !_obscurePassword;
//     notifyListeners();
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     _obscureConfirmPassword = !_obscureConfirmPassword;
//     notifyListeners();
//   }
//
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
//
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final userCredential = await _authService.signInWithEmailAndPassword(
//         email.trim(),
//         password,
//       );
//
//       if (userCredential.user != null) {
//         _currentUser = await _authService.getUserData(userCredential.user!.uid);
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       }
//
//       _errorMessage = 'Login failed';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = _getErrorMessage(e.code);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _errorMessage = 'An unexpected error occurred';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> register(String name, String email, String password) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final userCredential = await _authService.createUserWithEmailAndPassword(
//         name.trim(),
//         email.trim(),
//         password,
//       );
//
//       if (userCredential.user != null) {
//         _currentUser = await _authService.getUserData(userCredential.user!.uid);
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       }
//
//       _errorMessage = 'Registration failed';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = _getErrorMessage(e.code);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _errorMessage = 'An unexpected error occurred';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     await _authService.signOut();
//     _currentUser = null;
//     notifyListeners();
//   }
//
//   Future<bool> resetPassword(String email) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       await _authService.sendPasswordResetEmail(email.trim());
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = _getErrorMessage(e.code);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   String _getErrorMessage(String errorCode) {
//     switch (errorCode) {
//       case 'user-not-found':
//         return 'No user found with this email';
//       case 'wrong-password':
//         return 'Wrong password provided';
//       case 'invalid-email':
//         return 'The email address is not valid';
//       case 'user-disabled':
//         return 'This user has been disabled';
//       case 'invalid-credential':
//         return 'Invalid credentials';
//       case 'email-already-in-use':
//         return 'This email is already registered';
//       case 'weak-password':
//         return 'Password is too weak';
//       default:
//         return 'An error occurred. Please try again';
//     }
//   }
// }

// lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../services/auth_services.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  AuthViewModel(this._authService) {
    _initializeUser();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void _initializeUser() async {
    final user = _authService.currentUser;
    if (user != null) {
      _currentUser = await _authService.getUserData(user.uid);
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email.trim(),
        password,
      );

      if (userCredential.user != null) {
        _currentUser = await _authService.getUserData(userCredential.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        name.trim(),
        email.trim(),
        password,
      );

      if (userCredential.user != null) {
        _currentUser = await _authService.getUserData(userCredential.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'user-disabled':
        return 'This user has been disabled';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'An error occurred. Please try again';
    }
  }
}