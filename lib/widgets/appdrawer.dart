// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../services/auth_services.dart';
import '../viewmodel/auth_view_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      )
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      user?.displayName ?? 'Guest User',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // User Email
                    Text(
                      user?.email ?? 'guest@example.com',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Sign-in Method Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            authService.getSignInMethod() == 'Google'
                                ? Icons.g_mobiledata
                                : Icons.email,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            authService.getSignInMethod() ?? 'Email',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 8),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Home
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.home_rounded,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),

                    // My Lost Items
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.search_off_rounded,
                      title: 'My Lost Items',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/my_lost_items');
                      },
                    ),

                    // My Found Items
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.find_in_page_rounded,
                      title: 'My Found Items',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/my_found_items');
                      },
                    ),

                    // Report Lost Item
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.add_alert_rounded,
                      title: 'Report Lost Item',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/report_lost');
                      },
                    ),

                    // Report Found Item
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.add_location_rounded,
                      title: 'Report Found Item',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/report_found');
                      },
                    ),

                    const Divider(color: Colors.white24, height: 24),

                    // Profile
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.person_rounded,
                      title: 'Profile',
                      onTap: () {
                        Navigator.pop(context);
                        // The profile is already in bottom nav, so just close drawer
                      },
                    ),

                    // Settings
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),

                    // Help & Support
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.help_rounded,
                      title: 'Help & Support',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/help');
                      },
                    ),

                    // About
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.info_rounded,
                      title: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // App Version
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Lost & Back v1.0.0',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
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
              'Logout',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final viewModel = context.read<AuthViewModel>();
      await viewModel.logout();

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.find_in_page_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Lost & Back',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A community-driven platform to help reunite people with their lost belongings.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Lost & Back. All rights reserved.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}