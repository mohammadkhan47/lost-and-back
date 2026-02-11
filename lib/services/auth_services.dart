// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class AuthService {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   // Get current user
// //   User? get currentUser => _auth.currentUser;
// //
// //   // Auth state changes stream
// //   Stream<User?> get authStateChanges => _auth.authStateChanges();
// //
// //   // Sign in with email and password
// //   //UserCredential give important info about login ie register etc
// //   Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
// //     try {
// //       return await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Register with email and password
// //   Future<UserCredential> createUserWithEmailAndPassword(
// //       String name, String email, String password) async {
// //     try {
// //       // Create user with email and password
// //       final userCredential = await _auth.createUserWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //
// //       // Update display name
// //       await userCredential.user?.updateDisplayName(name);
// //
// //       // Create user document in Firestore
// //       await _firestore.collection('users').doc(userCredential.user!.uid).set({
// //         'uid': userCredential.user!.uid,
// //         'name': name,
// //         'email': email,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       });
// //
// //       return userCredential;
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Sign out
// //   Future<void> signOut() async {
// //     try {
// //       await _auth.signOut();
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Reset password
// //   Future<void> sendPasswordResetEmail(String email) async {
// //     try {
// //       await _auth.sendPasswordResetEmail(email: email);
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Verify password reset code
// //   Future<bool> verifyPasswordResetCode(String code) async {
// //     try {
// //       await _auth.verifyPasswordResetCode(code);
// //       return true;
// //     } catch (e) {
// //       return false;
// //     }
// //   }
// //
// //   // Confirm password reset
// //   Future<void> confirmPasswordReset(String code, String newPassword) async {
// //     try {
// //       await _auth.confirmPasswordReset(
// //         code: code,
// //         newPassword: newPassword,
// //       );
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Update user profile
// //   Future<void> updateProfile({String? displayName, String? photoURL}) async {
// //     try {
// //       await _auth.currentUser?.updateDisplayName(displayName);
// //       await _auth.currentUser?.updatePhotoURL(photoURL);
// //
// //       // Update Firestore document
// //       if (_auth.currentUser != null) {
// //         final updateData = <String, dynamic>{};
// //         if (displayName != null) updateData['name'] = displayName;
// //         if (photoURL != null) updateData['photoURL'] = photoURL;
// //
// //         await _firestore.collection('users').doc(_auth.currentUser!.uid).update(updateData);
// //       }
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Check if user's email is verified
// //   bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
// //
// //   // Send email verification
// //   Future<void> sendEmailVerification() async {
// //     try {
// //       await _auth.currentUser?.sendEmailVerification();
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// // }
//
// // lib/services/auth_service.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/user_model.dart';
// import '../utils/constants.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   Future<UserCredential> signInWithEmailAndPassword(
//       String email, String password) async {
//     return await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }
//
//   Future<UserCredential> createUserWithEmailAndPassword(
//       String name, String email, String password) async {
//     final userCredential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     await userCredential.user?.updateDisplayName(name);
//
//     // Create user document
//     final userModel = UserModel(
//       uid: userCredential.user!.uid,
//       email: email,
//       fullName: name,
//       createdAt: DateTime.now(),
//       points: 0,
//       badges: [],
//     );
//
//     await _firestore
//         .collection(AppConstants.usersCollection)
//         .doc(userCredential.user!.uid)
//         .set(userModel.toJson());
//
//     return userCredential;
//   }
//
//   Future<UserModel?> getUserData(String uid) async {
//     try {
//       final doc = await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(uid)
//           .get();
//
//       if (doc.exists) {
//         return UserModel.fromFirestore(doc);
//       }
//       return null;
//     } catch (e) {
//       print('Error getting user data: $e');
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
//
//   Future<void> sendPasswordResetEmail(String email) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }
//
//   Future<void> updateUserProfile({
//     String? displayName,
//     String? photoURL,
//     String? phoneNumber,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) return;
//
//     if (displayName != null) {
//       await user.updateDisplayName(displayName);
//     }
//     if (photoURL != null) {
//       await user.updatePhotoURL(photoURL);
//     }
//
//     final updateData = <String, dynamic>{};
//     if (displayName != null) updateData['fullName'] = displayName;
//     if (photoURL != null) updateData['photoUrl'] = photoURL;
//     if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
//
//     if (updateData.isNotEmpty) {
//       await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(user.uid)
//           .update(updateData);
//     }
//   }
// }



// lib/services/auth_services.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============================================
  // EMAIL & PASSWORD AUTHENTICATION
  // ============================================

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print('✅ Email sign in successful: ${result.user?.uid}');
      return result;

    } catch (e) {
      print('❌ Email sign in error: $e');
      rethrow;
    }
  }

  /// Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String name,
      String email,
      String password,
      ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userCredential.user?.updateDisplayName(name);

      // Create user document
      final userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        fullName: name,
        createdAt: DateTime.now(),
        points: 0,
        badges: [],
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      print('✅ Account created: ${userCredential.user!.uid}');
      return userCredential;

    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  // ============================================
  // GOOGLE SIGN-IN
  // ============================================

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔵 Starting Google Sign-In...');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print('⚠️ Google Sign-In canceled by user');
        return null;
      }

      print('📧 Google account selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      print('✅ Firebase sign in successful: ${userCredential.user?.uid}');

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        print('🆕 New user detected, creating Firestore document...');
        await _createUserFromGoogle(userCredential.user!);
      } else {
        print('👤 Existing user, checking Firestore document...');
        await _ensureUserDocumentExists(userCredential.user!);
      }

      return userCredential;

    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      print('   Message: ${e.message}');
      rethrow;

    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Create user document from Google account
  Future<void> _createUserFromGoogle(User user) async {
    try {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        points: 0,
        badges: [],
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());

      print('✅ User document created for Google account');

    } catch (e) {
      print('❌ Error creating user document: $e');
      rethrow;
    }
  }

  /// Ensure user document exists (for existing Google users)
  Future<void> _ensureUserDocumentExists(User user) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        print('⚠️ User document missing, creating...');
        await _createUserFromGoogle(user);
      } else {
        print('✅ User document exists');
      }

    } catch (e) {
      print('❌ Error checking user document: $e');
      rethrow;
    }
  }

  // ============================================
  // PASSWORD RESET
  // ============================================

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final trimmedEmail = email.trim();

      print('📧 Sending password reset email to: $trimmedEmail');

      // Just send the email - Firebase will handle if user doesn't exist
      await _auth.sendPasswordResetEmail(email: trimmedEmail);

      print('✅ Password reset email sent!');
      print('📬 If the email exists, password reset link was sent');

    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');

      switch (e.code) {
        case 'invalid-email':
          throw FirebaseAuthException(
            code: e.code,
            message: 'Invalid email address format',
          );
        case 'user-not-found':
        // For security, we don't reveal if email exists or not
        // Just pretend it was sent successfully
          print('⚠️ User not found, but not revealing to user');
          return; // Don't throw error
        case 'user-disabled':
          throw FirebaseAuthException(
            code: e.code,
            message: 'This account has been disabled',
          );
        case 'too-many-requests':
          throw FirebaseAuthException(
            code: e.code,
            message: 'Too many attempts. Try again later',
          );
        default:
          rethrow;
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// Check if email exists (alternative method without deprecated API)
  Future<bool> checkEmailExists(String email) async {
    try {
      // Try to create a temporary sign-in attempt to check if email exists
      // This is not ideal but works as an alternative

      // Better approach: Check Firestore directly
      final querySnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;

    } catch (e) {
      print('❌ Error checking email: $e');
      return false;
    }
  }

  // ============================================
  // USER DATA
  // ============================================

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }

      print('⚠️ User document not found: $uid');
      return null;

    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    try {
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['fullName'] = displayName;
      if (photoURL != null) updateData['photoUrl'] = photoURL;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;

      if (updateData.isNotEmpty) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .update(updateData);
      }

      print('✅ User profile updated');

    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  // ============================================
  // SIGN OUT
  // ============================================

  /// Sign out (handles both email and Google sign-in)
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        print('✅ Google Sign-Out successful');
      }

      // Sign out from Firebase
      await _auth.signOut();
      print('✅ Firebase Sign-Out successful');

    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  // ============================================
  // ACCOUNT MANAGEMENT
  // ============================================

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      // Delete Firestore document
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .delete();

      // Sign out from Google if needed
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      // Delete Firebase Auth account
      await user.delete();

      print('✅ Account deleted');

    } catch (e) {
      print('❌ Error deleting account: $e');
      rethrow;
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      print('✅ Verification email sent');
    } catch (e) {
      print('❌ Error sending verification: $e');
      rethrow;
    }
  }

  /// Reload current user
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      print('❌ Error reloading user: $e');
      rethrow;
    }
  }

  /// Get sign-in method used
  String? getSignInMethod() {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Check provider data
    for (var provider in user.providerData) {
      if (provider.providerId == 'google.com') {
        return 'Google';
      } else if (provider.providerId == 'password') {
        return 'Email';
      }
    }
    return 'Unknown';
  }
}