import 'package:cloud_firestore/cloud_firestore.dart';

class FoundItemModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final List<String> imageUrls;
  final GeoPoint location;
  final String locationName;
  final DateTime dateFound;
  final String status; // 'active', 'claimed', 'closed'
  final DateTime createdAt;
  final bool verified;
  final String? matchedLostItemId;

  FoundItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrls,
    required this.location,
    required this.locationName,
    required this.dateFound,
    this.status = 'active',
    required this.createdAt,
    this.verified = false,
    this.matchedLostItemId,
  });

  factory FoundItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FoundItemModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      location: data['location'] ?? const GeoPoint(0, 0),
      locationName: data['locationName'] ?? '',
      dateFound: (data['dateFound'] as Timestamp).toDate(),
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      verified: data['verified'] ?? false,
      matchedLostItemId: data['matchedLostItemId'],
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
      'dateFound': Timestamp.fromDate(dateFound),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'verified': verified,
      'matchedLostItemId': matchedLostItemId,
    };
  }
}