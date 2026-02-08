// lib/views/home/dashboard_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../services/auth_services.dart';
import '../../model/user_model.dart';
import '../../model/lost_items_model.dart';
import '../../model/found_item_model.dart';
import '../../viewmodel/lost_item_viewmodel.dart';
import '../../viewmodel/found_item_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      setState(() {
        _currentUser = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lostItemViewModel = context.watch<LostItemViewModel>();
    final foundItemViewModel = context.watch<FoundItemViewModel>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
          },
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: _buildQuickStats(),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: _buildQuickActions(),
              ),

              // Recent Lost Items Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Lost Items',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to lost items list
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Lost Items List
              SliverToBoxAdapter(
                child: _buildRecentLostItems(lostItemViewModel.lostItems),
              ),

              // Recent Found Items Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Found Items',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to found items list
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Found Items List
              SliverToBoxAdapter(
                child: _buildRecentFoundItems(foundItemViewModel.foundItems),
              ),

              // Bottom Padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: _currentUser?.photoUrl != null
                ? ClipOval(
              child: Image.network(
                _currentUser!.photoUrl!,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _currentUser?.fullName ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Notification Icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Notifications coming soon!',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.star_rounded,
                label: 'Points',
                value: '${_currentUser?.points ?? 0}',
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.emoji_events_rounded,
                label: 'Badges',
                value: '${_currentUser?.badges.length ?? 0}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.search_off_rounded,
                  label: 'Report Lost',
                  color: AppColors.error,
                  onTap: () {
                    Navigator.pushNamed(context, '/report_lost');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Report Found',
                  color: AppColors.success,
                  onTap: () {
                    Navigator.pushNamed(context, '/report_found');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLostItems(List<LostItemModel> items) {
    if (items.isEmpty) {
      return _buildEmptySection('No recent lost items');
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.take(5).length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildLostItemCard(item);
        },
      ),
    );
  }

  Widget _buildRecentFoundItems(List<FoundItemModel> items) {
    if (items.isEmpty) {
      return _buildEmptySection('No recent found items');
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.take(5).length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildFoundItemCard(item);
        },
      ),
    );
  }

  Widget _buildLostItemCard(LostItemModel item) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: item.imageUrls.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: item.imageUrls.first,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 100,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item.locationName,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundItemCard(FoundItemModel item) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: item.imageUrls.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: item.imageUrls.first,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 100,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item.locationName,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySection(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}