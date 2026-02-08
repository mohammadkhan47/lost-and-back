// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Get current user
//   User? get currentUser => _auth.currentUser;
//
//   // Auth state changes stream
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   // Sign in with email and password
//   //UserCredential give important info about login ie register etc
//   Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Register with email and password
//   Future<UserCredential> createUserWithEmailAndPassword(
//       String name, String email, String password) async {
//     try {
//       // Create user with email and password
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Update display name
//       await userCredential.user?.updateDisplayName(name);
//
//       // Create user document in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'name': name,
//         'email': email,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       return userCredential;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Reset password
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Verify password reset code
//   Future<bool> verifyPasswordResetCode(String code) async {
//     try {
//       await _auth.verifyPasswordResetCode(code);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   // Confirm password reset
//   Future<void> confirmPasswordReset(String code, String newPassword) async {
//     try {
//       await _auth.confirmPasswordReset(
//         code: code,
//         newPassword: newPassword,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Update user profile
//   Future<void> updateProfile({String? displayName, String? photoURL}) async {
//     try {
//       await _auth.currentUser?.updateDisplayName(displayName);
//       await _auth.currentUser?.updatePhotoURL(photoURL);
//
//       // Update Firestore document
//       if (_auth.currentUser != null) {
//         final updateData = <String, dynamic>{};
//         if (displayName != null) updateData['name'] = displayName;
//         if (photoURL != null) updateData['photoURL'] = photoURL;
//
//         await _firestore.collection('users').doc(_auth.currentUser!.uid).update(updateData);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Check if user's email is verified
//   bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
//
//   // Send email verification
//   Future<void> sendEmailVerification() async {
//     try {
//       await _auth.currentUser?.sendEmailVerification();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(name);

    // Create user document
    final userModel = UserModel(
      uid: userCredential.user!.uid,
      email: email,
      fullName: name,
      createdAt: DateTime.now(),
      points: 0,
      badges: [],
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userCredential.user!.uid)
        .set(userModel.toJson());

    return userCredential;
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

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
  }
}