// lib/viewmodels/lost_item_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//
// import '../model/lost_items_model.dart';
// import '../services/database_services.dart';
// import '../services/notification_services.dart';
// import '../services/storage_services.dart';
//
// class LostItemViewModel extends ChangeNotifier {
//   final DatabaseService _databaseService = DatabaseService();
//   final StorageService _storageService = StorageService();
//   final NotificationService _notificationService = NotificationService();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   bool _isLoading = false;
//   String? _errorMessage;
//   List<LostItemModel> _lostItems = [];
//   List<LostItemModel> _userLostItems = [];
//
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   List<LostItemModel> get lostItems => _lostItems;
//   List<LostItemModel> get userLostItems => _userLostItems;
//
//   LostItemViewModel() {
//     _initializeStreams();
//   }
//
//   void _initializeStreams() {
//     final userId = _auth.currentUser?.uid;
//
//     // Listen to all lost items
//     _databaseService.getLostItems().listen((items) {
//       _lostItems = items;
//       notifyListeners();
//     });
//
//     // Listen to user's lost items
//     if (userId != null) {
//       _databaseService.getUserLostItems(userId).listen((items) {
//         _userLostItems = items;
//         notifyListeners();
//       });
//     }
//   }
//
//   Future<bool> reportLostItem({
//     required String title,
//     required String description,
//     required String category,
//     required List<XFile> images,
//     required double latitude,
//     required double longitude,
//     required String locationName,
//     required DateTime dateLost,
//     int? rewardPoints,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       // Generate temporary ID
//       final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//
//       // Upload images
//       final imageUrls = await _storageService.uploadItemImages(images, tempId);
//
//       // Create lost item
//       final lostItem = LostItemModel(
//         id: '',
//         userId: userId,
//         title: title,
//         description: description,
//         category: category,
//         imageUrls: imageUrls,
//         location: GeoPoint(latitude, longitude),
//         locationName: locationName,
//         dateLost: dateLost,
//         rewardPoints: rewardPoints,
//         createdAt: DateTime.now(),
//         status: 'active',
//         verified: false,
//       );
//
//       // Add to database
//       await _databaseService.addLostItem(lostItem);
//
//       // Send notification to nearby users (implement later)
//       await _notificationService.sendLocalNotification(
//         title: 'Lost Item Reported',
//         body: 'Your lost item "$title" has been reported successfully',
//       );
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> updateItemStatus(String itemId, String status) async {
//     try {
//       await _databaseService.updateLostItemStatus(itemId, status);
//     } catch (e) {
//       _errorMessage = e.toString();
//       notifyListeners();
//     }
//   }
//
//   Future<void> deleteItem(String itemId) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       await _databaseService.deleteLostItem(itemId);
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _errorMessage = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }


// lib/viewmodels/lost_item_viewmodel.dart
// UPDATED TO USE CLOUDINARY INSTEAD OF FIREBASE STORAGE

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/lost_items_model.dart';
import '../services/cloudinary_storage_services.dart';
import '../services/database_services.dart';
import '../services/notification_services.dart';

class LostItemViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final CloudinaryStorageService _storageService = CloudinaryStorageService();  // ✅ CHANGED THIS LINE
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<LostItemModel> _lostItems = [];
  List<LostItemModel> _userLostItems = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<LostItemModel> get lostItems => _lostItems;
  List<LostItemModel> get userLostItems => _userLostItems;

  LostItemViewModel() {
    _initializeStreams();
  }

  void _initializeStreams() {
    final userId = _auth.currentUser?.uid;

    // Listen to all lost items
    _databaseService.getLostItems().listen((items) {
      _lostItems = items;
      notifyListeners();
    });

    // Listen to user's lost items
    if (userId != null) {
      _databaseService.getUserLostItems(userId).listen((items) {
        _userLostItems = items;
        notifyListeners();
      });
    }
  }

  Future<bool> reportLostItem({
    required String title,
    required String description,
    required String category,
    required List<XFile> images,
    required double latitude,
    required double longitude,
    required String locationName,
    required DateTime dateLost,
    int? rewardPoints,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate temporary ID
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload images to Cloudinary (FREE!)
      final imageUrls = await _storageService.uploadItemImages(images, tempId);

      // Create lost item
      final lostItem = LostItemModel(
        id: '',
        userId: userId,
        title: title,
        description: description,
        category: category,
        imageUrls: imageUrls,
        location: GeoPoint(latitude, longitude),
        locationName: locationName,
        dateLost: dateLost,
        rewardPoints: rewardPoints,
        createdAt: DateTime.now(),
        status: 'active',
        verified: false,
      );

      // Add to database
      await _databaseService.addLostItem(lostItem);

      // Send notification
      await _notificationService.sendLocalNotification(
        title: 'Lost Item Reported',
        body: 'Your lost item "$title" has been reported successfully',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateItemStatus(String itemId, String status) async {
    try {
      await _databaseService.updateLostItemStatus(itemId, status);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteLostItem(itemId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}