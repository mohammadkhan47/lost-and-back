// lib/views/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/colors.dart';
import '../../services/auth_services.dart';
import '../../model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Settings coming soon!',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Stats Cards
            _buildStatsSection(),
            const SizedBox(height: 24),

            // Menu Items
            _buildMenuSection(),
            const SizedBox(height: 24),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: _currentUser?.photoUrl != null
                ? ClipOval(
              child: Image.network(
                _currentUser!.photoUrl!,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.person_rounded,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            _currentUser?.fullName ?? 'User',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            _currentUser?.email ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          // Phone (if available)
          if (_currentUser?.phoneNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              _currentUser!.phoneNumber!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.star_rounded,
              label: 'Points',
              value: '${_currentUser?.points ?? 0}',
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.emoji_events_rounded,
              label: 'Badges',
              value: '${_currentUser?.badges.length ?? 0}',
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.search_rounded,
          title: 'My Lost Items',
          subtitle: 'View items you reported as lost',
          onTap: () {
            Navigator.pushNamed(context, '/my_lost_items');
          },
        ),
        _buildMenuItem(
          icon: Icons.find_in_page_rounded,
          title: 'My Found Items',
          subtitle: 'View items you reported as found',
          onTap: () {
            Navigator.pushNamed(context, '/my_found_items');
          },
        ),
        _buildMenuItem(
          icon: Icons.history_rounded,
          title: 'Activity History',
          subtitle: 'View your past activities',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Activity History coming soon!',
                  style: GoogleFonts.poppins(),
                ),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          subtitle: 'Manage your notifications',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Notifications coming soon!',
                  style: GoogleFonts.poppins(),
                ),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Help & Support coming soon!',
                  style: GoogleFonts.poppins(),
                ),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Lost & Found',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 Lost & Found App',
              children: [
                const SizedBox(height: 16),
                Text(
                  'A community-driven platform to help reunite lost items with their owners.',
                  style: GoogleFonts.poppins(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}