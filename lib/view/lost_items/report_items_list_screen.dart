// lib/views/lost_items/lost_items_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/lost_items_model.dart';
import '../../utils/colors.dart';
import '../../viewmodel/lost_item_viewmodel.dart';
import 'lost_item_detail_screem.dart';

class LostItemsListScreen extends StatefulWidget {
  const LostItemsListScreen({Key? key}) : super(key: key);

  @override
  State<LostItemsListScreen> createState() => _LostItemsListScreenState();
}

class _LostItemsListScreenState extends State<LostItemsListScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LostItemViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lost Items',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(),
          ),

          // Category Filter
          _buildCategoryFilter(),

          // Items List
          Expanded(
            child: viewModel.lostItems.isEmpty
                ? _buildEmptyState()
                : _buildItemsList(viewModel.lostItems),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/report_lost');
        },
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Report Lost',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search lost items...',
          hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.error),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          )
              : null,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All'),
          ...['Electronics', 'Documents', 'Bags', 'Keys', 'Wallets', 'Others']
              .map((category) => _buildCategoryChip(category)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          category,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.error,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildItemsList(List<LostItemModel> items) {
    // Filter items
    var filteredItems = items.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.category == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
          item.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildItemCard(filteredItems[index]);
      },
    );
  }

  Widget _buildItemCard(LostItemModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LostItemDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: item.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: item.imageUrls.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, size: 50),
                ),
              )
                  : Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Category & Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(item.dateLost),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.locationName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Reward (if exists)
                  if (item.rewardPoints != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '${item.rewardPoints} Points Reward',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Lost Items Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}