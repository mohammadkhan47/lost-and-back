// lib/model/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? photoUrl;
  final int points;
  final List<String> badges;
  final DateTime createdAt;
  final GeoPoint? location;
  final bool isAdmin;
  final bool isBlocked;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.photoUrl,
    this.points = 0,
    this.badges = const [],
    required this.createdAt,
    this.location,
    this.isAdmin = false,
    this.isBlocked = false,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'],
      photoUrl: data['photoUrl'],
      points: data['points'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      location: data['location'],
      isAdmin: data['isAdmin'] ?? false,
      isBlocked: data['isBlocked'] ?? false,
    );
  }

  // ✅ ADDED: Create from Firebase Auth User
  factory UserModel.fromFirebaseAuthUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? 'User',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
      points: 0,
      badges: [],
      isAdmin: false,
      isBlocked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'points': points,
      'badges': badges,
      'createdAt': Timestamp.fromDate(createdAt),
      'location': location,
      'isAdmin': isAdmin,
      'isBlocked': isBlocked,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? photoUrl,
    int? points,
    List<String>? badges,
    DateTime? createdAt,
    GeoPoint? location,
    bool? isAdmin,
    bool? isBlocked,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      points: points ?? this.points,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}