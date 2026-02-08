// lib/views/lost_items/lost_item_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/lost_items_model.dart';
import '../../utils/colors.dart';

class LostItemDetailScreen extends StatelessWidget {
  final LostItemModel item;

  const LostItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
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