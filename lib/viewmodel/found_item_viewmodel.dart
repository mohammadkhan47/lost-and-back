// lib/viewmodels/found_item_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/found_item_model.dart';
import '../services/database_services.dart';
import '../services/notification_services.dart';
import '../services/storage_services.dart';

class FoundItemViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<FoundItemModel> _foundItems = [];
  List<FoundItemModel> _userFoundItems = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FoundItemModel> get foundItems => _foundItems;
  List<FoundItemModel> get userFoundItems => _userFoundItems;

  FoundItemViewModel() {
    _initializeStreams();
  }

  void _initializeStreams() {
    final userId = _auth.currentUser?.uid;

    _databaseService.getFoundItems().listen((items) {
      _foundItems = items;
      notifyListeners();
    });

    if (userId != null) {
      _databaseService.getUserFoundItems(userId).listen((items) {
        _userFoundItems = items;
        notifyListeners();
      });
    }
  }

  Future<bool> reportFoundItem({
    required String title,
    required String description,
    required String category,
    required List<XFile> images,
    required double latitude,
    required double longitude,
    required String locationName,
    required DateTime dateFound,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final imageUrls = await _storageService.uploadItemImages(images, tempId);

      final foundItem = FoundItemModel(
        id: '',
        userId: userId,
        title: title,
        description: description,
        category: category,
        imageUrls: imageUrls,
        location: GeoPoint(latitude, longitude),
        locationName: locationName,
        dateFound: dateFound,
        createdAt: DateTime.now(),
        status: 'active',
        verified: false,
      );

      await _databaseService.addFoundItem(foundItem);

      await _notificationService.sendLocalNotification(
        title: 'Found Item Reported',
        body: 'Your found item "$title" has been reported successfully',
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
      await _databaseService.updateFoundItemStatus(itemId, status);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteFoundItem(itemId);
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