// lib/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> uploadItemImages(
      List<XFile> images, String itemId) async {
    List<String> imageUrls = [];

    for (int i = 0; i < images.length; i++) {
      final file = File(images[i].path);
      final fileName = '${itemId}_$i.jpg';
      final ref = _storage.ref().child('items/$itemId/$fileName');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }

    return imageUrls;
  }

  Future<String> uploadProfileImage(XFile image, String userId) async {
    final file = File(image.path);
    final ref = _storage.ref().child('profiles/$userId.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
  }

  Future<List<XFile>> pickMultipleImages({int maxImages = 3}) async {
    final images = await _picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    return images.take(maxImages).toList();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}