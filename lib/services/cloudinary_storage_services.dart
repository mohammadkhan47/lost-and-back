// lib/services/cloudinary_storage_service.dart
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// FREE Storage Service using Cloudinary
/// No credit card required, 25GB free storage!
class CloudinaryStorageService {
  // TODO: Replace with your Cloudinary credentials from https://cloudinary.com
  static const String cloudName = 'dzarrgpkv';  // Your cloud name
  static const String uploadPreset = 'lostandback';  // Your preset name

  late final CloudinaryPublic _cloudinary;
  final ImagePicker _picker = ImagePicker();

  CloudinaryStorageService() {
    _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }

  /// Upload multiple images for an item
  Future<List<String>> uploadItemImages(
      List<XFile> images,
      String itemId,
      ) async {
    List<String> imageUrls = [];

    try {
      print('📤 Starting Cloudinary upload of ${images.length} images');

      for (int i = 0; i < images.length; i++) {
        try {
          print('📤 Uploading image ${i + 1}/${images.length}...');

          // Compress image
          final compressedFile = await _compressImage(File(images[i].path));

          // Upload to Cloudinary
          final response = await _cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              compressedFile.path,
              folder: 'lost-and-back/items/$itemId',
              resourceType: CloudinaryResourceType.Image,
            ),
          );

          // Get secure URL
          final url = response.secureUrl;
          imageUrls.add(url);

          print('✅ Image ${i + 1} uploaded: ${response.publicId}');
        } catch (e) {
          print('❌ Error uploading image ${i + 1}: $e');
          throw Exception('Failed to upload image ${i + 1}: $e');
        }
      }

      print('✅ All images uploaded successfully! Total: ${imageUrls.length}');
      return imageUrls;
    } catch (e) {
      print('❌ Cloudinary upload error: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage(XFile image, String userId) async {
    try {
      print('📤 Uploading profile image for user: $userId');

      final compressedFile = await _compressImage(File(image.path));

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedFile.path,
          folder: 'lost-and-back/profiles',
          resourceType: CloudinaryResourceType.Image,
          publicId: userId, // Use userId as filename
        ),
      );

      print('✅ Profile image uploaded: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      print('❌ Error uploading profile image: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Compress image before upload
  Future<File> _compressImage(File file) async {
    try {
      print('🗜️ Compressing image: ${path.basename(file.path)}');

      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (compressedFile == null) {
        print('⚠️ Compression failed, using original file');
        return file;
      }

      final originalSize = await file.length();
      final compressedSize = await compressedFile.length();
      final reduction =
      ((originalSize - compressedSize) / originalSize * 100).round();

      print('✅ Compressed: ${originalSize}B → ${compressedSize}B ($reduction% reduction)');

      return File(compressedFile.path);
    } catch (e) {
      print('⚠️ Compression error: $e, using original');
      return file;
    }
  }

  /// Pick single image
  Future<XFile?> pickImage() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      print('❌ Error picking image: $e');
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick multiple images
  Future<List<XFile>> pickMultipleImages({int maxImages = 3}) async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (images.length > maxImages) {
        print('⚠️ Selected ${images.length} images, limiting to $maxImages');
      }

      return images.take(maxImages).toList();
    } catch (e) {
      print('❌ Error picking images: $e');
      throw Exception('Failed to pick images: $e');
    }
  }

  /// Delete image (Cloudinary keeps all uploads, deletion requires auth token)
  /// For free tier, you can manage via Cloudinary dashboard
  Future<void> deleteImage(String imageUrl) async {
    try {
      print('⚠️ Image deletion requires Cloudinary API key');
      print('Please delete manually from Cloudinary dashboard');
      print('URL: $imageUrl');
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}