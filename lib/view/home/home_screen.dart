// lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../lost_items/report_items_list_screen.dart';
import 'dashboard_screen.dart';
import '../found_items/found_items_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LostItemsListScreen(),
    const FoundItemsListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Lost Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_rounded),
              label: 'Found Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () => _showReportOptions(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Report Item',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : null,
    );
  }

  void _showReportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Report an Item',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Report Lost Item
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    color: AppColors.error,
                  ),
                ),
                title: Text(
                  'I Lost Something',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Report your lost item',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/report_lost');
                },
              ),
              const SizedBox(height: 12),

              // Report Found Item
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                  ),
                ),
                title: Text(
                  'I Found Something',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Report an item you found',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/report_found');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}