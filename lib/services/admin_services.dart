// lib/services/admin_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import '../model/lost_items_model.dart';
import '../model/found_item_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // USER MANAGEMENT
  // ============================================

  /// Get all users
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList());
  }

  /// Block/Unblock user
  Future<void> toggleUserBlock(String userId, bool isBlocked) async {
    await _firestore.collection('users').doc(userId).update({
      'isBlocked': isBlocked,
    });
  }

  /// Make user admin
  Future<void> toggleUserAdmin(String userId, bool isAdmin) async {
    await _firestore.collection('users').doc(userId).update({
      'isAdmin': isAdmin,
    });
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // ============================================
  // ITEM MANAGEMENT
  // ============================================

  /// Get all lost items
  Stream<List<LostItemModel>> getAllLostItems() {
    return _firestore
        .collection('lostItems')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => LostItemModel.fromFirestore(doc))
        .toList());
  }

  /// Get all found items
  Stream<List<FoundItemModel>> getAllFoundItems() {
    return _firestore
        .collection('foundItems')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FoundItemModel.fromFirestore(doc))
        .toList());
  }

  /// Delete lost item
  Future<void> deleteLostItem(String itemId) async {
    await _firestore.collection('lostItems').doc(itemId).delete();
  }

  /// Delete found item
  Future<void> deleteFoundItem(String itemId) async {
    await _firestore.collection('foundItems').doc(itemId).delete();
  }

  /// Verify item
  Future<void> verifyItem(String itemId, bool isLost) async {
    final collection = isLost ? 'lostItems' : 'foundItems';
    await _firestore.collection(collection).doc(itemId).update({
      'verified': true,
    });
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Get user count
  Future<int> getUserCount() async {
    final snapshot = await _firestore.collection('users').count().get();
    return snapshot.count ?? 0;
  }

  /// Get lost items count
  Future<int> getLostItemsCount() async {
    final snapshot = await _firestore.collection('lostItems').count().get();
    return snapshot.count ?? 0;
  }

  /// Get found items count
  Future<int> getFoundItemsCount() async {
    final snapshot = await _firestore.collection('foundItems').count().get();
    return snapshot.count ?? 0;
  }

  /// Get blocked users count
  Future<int> getBlockedUsersCount() async {
    final snapshot = await _firestore
        .collection('users')
        .where('isBlocked', isEqualTo: true)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}