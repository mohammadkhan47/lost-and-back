// lib/services/database_service.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/found_item_model.dart';
import '../model/lost_items_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lost Items
  Future<String> addLostItem(LostItemModel item) async {
    final docRef = await _firestore
        .collection(AppConstants.lostItemsCollection)
        .add(item.toJson());
    return docRef.id;
  }

  Stream<List<LostItemModel>> getLostItems({int limit = 20}) {
    return _firestore
        .collection(AppConstants.lostItemsCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => LostItemModel.fromFirestore(doc))
        .toList());
  }

  Stream<List<LostItemModel>> getUserLostItems(String userId) {
    return _firestore
        .collection(AppConstants.lostItemsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => LostItemModel.fromFirestore(doc))
        .toList());
  }

  Future<void> updateLostItemStatus(String itemId, String status) async {
    await _firestore
        .collection(AppConstants.lostItemsCollection)
        .doc(itemId)
        .update({'status': status});
  }

  // Found Items
  Future<String> addFoundItem(FoundItemModel item) async {
    final docRef = await _firestore
        .collection(AppConstants.foundItemsCollection)
        .add(item.toJson());
    return docRef.id;
  }

  Stream<List<FoundItemModel>> getFoundItems({int limit = 20}) {
    return _firestore
        .collection(AppConstants.foundItemsCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FoundItemModel.fromFirestore(doc))
        .toList());
  }

  Stream<List<FoundItemModel>> getUserFoundItems(String userId) {
    return _firestore
        .collection(AppConstants.foundItemsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FoundItemModel.fromFirestore(doc))
        .toList());
  }

  Future<void> updateFoundItemStatus(String itemId, String status) async {
    await _firestore
        .collection(AppConstants.foundItemsCollection)
        .doc(itemId)
        .update({'status': status});
  }

  // Search nearby items
  Future<List<LostItemModel>> searchNearbyLostItems({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    // Note: For production, use GeoFlutterFire for better geolocation queries
    final snapshot = await _firestore
        .collection(AppConstants.lostItemsCollection)
        .where('status', isEqualTo: 'active')
        .get();

    return snapshot.docs
        .map((doc) => LostItemModel.fromFirestore(doc))
        .where((item) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        item.location.latitude,
        item.location.longitude,
      );
      return distance <= radiusInKm;
    }).toList();
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {

    const double earthRadius = 6371; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_toRadians(lat1)) *
                cos(_toRadians(lat2)) *
                sin(dLon / 2) *
                sin(dLon / 2);

    final double c =
        2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180);
  }

  // Delete item
  Future<void> deleteLostItem(String itemId) async {
    await _firestore
        .collection(AppConstants.lostItemsCollection)
        .doc(itemId)
        .delete();
  }

  Future<void> deleteFoundItem(String itemId) async {
    await _firestore
        .collection(AppConstants.foundItemsCollection)
        .doc(itemId)
        .delete();
  }
}