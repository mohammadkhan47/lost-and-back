// lib/views/found_items/report_found_item_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../viewmodel/found_item_viewmodel.dart';

class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({Key? key}) : super(key: key);

  @override
  State<ReportFoundItemScreen> createState() => _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = AppConstants.itemCategories[0];
  DateTime _selectedDate = DateTime.now();
  List<XFile> _selectedImages = [];
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (images.length > AppConstants.maxImagesPerItem) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'You can only select up to ${AppConstants.maxImagesPerItem} images'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _selectedImages = images;
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      _locationController.text =
      'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, '
          'Long: ${_currentPosition!.longitude.toStringAsFixed(4)}';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get location: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.success,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final viewModel = context.read<FoundItemViewModel>();

    final success = await viewModel.reportFoundItem(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      images: _selectedImages,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      locationName: _locationController.text.trim(),
      dateFound: _selectedDate,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Found item reported successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FoundItemViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report Found Item',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  _buildSectionTitle('Item Photos'),
                  const SizedBox(height: 12),
                  _buildImagePicker(),
                  const SizedBox(height: 24),

                  // Title
                  _buildSectionTitle('Item Title'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _titleController,
                    hintText: 'e.g., Blue Wallet',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category
                  _buildSectionTitle('Category'),
                  const SizedBox(height: 12),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),

                  // Description
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    hintText: 'Describe the item in detail...',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Location
                  _buildSectionTitle('Found Location'),
                  const SizedBox(height: 12),
                  _buildLocationField(),
                  const SizedBox(height: 20),

                  // Date Found
                  _buildSectionTitle('Date Found'),
                  const SizedBox(height: 12),
                  _buildDateField(),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Report Found Item',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Error Message
          if (viewModel.errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.error,
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.success, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: _selectedImages.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate_rounded,
                size: 48, color: AppColors.success),
            const SizedBox(height: 8),
            Text(
              'Add Photos (Up to ${AppConstants.maxImagesPerItem})',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ],
        )
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(_selectedImages[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: AppConstants.itemCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category, style: GoogleFonts.poppins()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedCategory = value!);
          },
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _locationController,
            hintText: 'Select location',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select location';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isLoadingLocation
              ? const Center(
              child: CircularProgressIndicator(color: Colors.white))
              : IconButton(
            icon: const Icon(Icons.my_location_rounded,
                color: Colors.white),
            onPressed: _getCurrentLocation,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: AppColors.success),
            const SizedBox(width: 12),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}