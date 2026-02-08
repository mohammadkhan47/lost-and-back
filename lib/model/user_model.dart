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
  });

  // Factory constructor from Firestore document
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
    );
  }

  // Factory constructor from Firebase User (for quick creation)
  factory UserModel.fromFirebaseAuthUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      fullName: firebaseUser.displayName ?? 'User',
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      points: 0,
      badges: [],
      createdAt: DateTime.now(),
    );
  }

  // Convert to JSON for Firestore
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
    };
  }

  // Copy with method for easy updates
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
    );
  }
}