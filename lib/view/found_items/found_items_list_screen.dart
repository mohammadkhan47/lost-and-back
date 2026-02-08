// lib/views/found_items/found_items_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/found_item_model.dart';
import '../../utils/colors.dart';
import '../../viewmodel/found_item_viewmodel.dart';

class FoundItemsListScreen extends StatefulWidget {
  const FoundItemsListScreen({Key? key}) : super(key: key);

  @override
  State<FoundItemsListScreen> createState() => _FoundItemsListScreenState();
}

class _FoundItemsListScreenState extends State<FoundItemsListScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FoundItemViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Found Items',
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
            child: viewModel.foundItems.isEmpty
                ? _buildEmptyState()
                : _buildItemsList(viewModel.foundItems),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/report_found');
        },
        backgroundColor: AppColors.success,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Report Found',
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
          hintText: 'Search found items...',
          hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.success),
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
        selectedColor: AppColors.success,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildItemsList(List<FoundItemModel> items) {
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

  Widget _buildItemCard(FoundItemModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoundItemDetailScreen(item: item),
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
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(item.dateFound),
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
                          size: 16, color: AppColors.success),
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

                  // Verified Badge
                  if (item.verified) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded,
                              size: 16, color: AppColors.info),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.info,
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
          Icon(Icons.find_in_page_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Found Items',
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

// Placeholder for FoundItemDetailScreen
class FoundItemDetailScreen extends StatelessWidget {
  final FoundItemModel item;

  const FoundItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text(
          'Detail screen for: ${item.title}',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }
}