import 'package:cloud_firestore/cloud_firestore.dart';

class LostItemModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final List<String> imageUrls;
  final GeoPoint location;
  final String locationName;
  final DateTime dateLost;
  final String status; // 'active', 'found', 'closed'
  final int? rewardPoints;
  final DateTime createdAt;
  final bool verified;

  LostItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrls,
    required this.location,
    required this.locationName,
    required this.dateLost,
    this.status = 'active',
    this.rewardPoints,
    required this.createdAt,
    this.verified = false,
  });

  factory LostItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LostItemModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      location: data['location'] ?? const GeoPoint(0, 0),
      locationName: data['locationName'] ?? '',
      dateLost: (data['dateLost'] as Timestamp).toDate(),
      status: data['status'] ?? 'active',
      rewardPoints: data['rewardPoints'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      verified: data['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'imageUrls': imageUrls,
      'location': location,
      'locationName': locationName,
      'dateLost': Timestamp.fromDate(dateLost),
      'status': status,
      'rewardPoints': rewardPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      'verified': verified,
    };
  }
}