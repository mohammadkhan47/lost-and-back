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


// lib/viewmodel/auth_view_model.dart
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

  // ============================================
  // EMAIL AUTHENTICATION
  // ============================================

  /// Login with email and password
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

        if (_currentUser == null) {
          _currentUser = UserModel.fromFirebaseAuthUser(userCredential.user!);
        }

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

  /// Register with email and password
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

  // ============================================
  // GOOGLE SIGN-IN
  // ============================================

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔵 Starting Google Sign-In from ViewModel...');

      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        // User canceled
        print('⚠️ Google Sign-In canceled');
        _errorMessage = null; // Don't show error for cancellation
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (userCredential.user != null) {
        print('✅ Getting user data from Firestore...');

        _currentUser = await _authService.getUserData(userCredential.user!.uid);

        if (_currentUser == null) {
          // Fallback if Firestore doc doesn't exist yet
          _currentUser = UserModel.fromFirebaseAuthUser(userCredential.user!);
        }

        print('✅ Google Sign-In complete! User: ${_currentUser?.fullName}');

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Google sign-in failed';
      _isLoading = false;
      notifyListeners();
      return false;

    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error in ViewModel: ${e.code}');
      _errorMessage = _getGoogleSignInError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;

    } catch (e) {
      print('❌ Unexpected error in ViewModel: $e');
      _errorMessage = 'Failed to sign in with Google';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================
  // PASSWORD RESET
  // ============================================

  /// Reset password
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

  // ============================================
  // LOGOUT
  // ============================================

  /// Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('❌ Logout error: $e');
      _errorMessage = 'Failed to sign out';
      notifyListeners();
    }
  }

  // ============================================
  // ERROR HANDLING
  // ============================================

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'An error occurred. Please try again';
    }
  }

  String _getGoogleSignInError(String errorCode) {
    switch (errorCode) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method';
      case 'invalid-credential':
        return 'The credential is malformed or expired';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Google sign-in failed. Please try again';
    }
  }

  /// Get current sign-in method
  String? getSignInMethod() {
    return _authService.getSignInMethod();
  }
}