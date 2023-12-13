import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Set the height of the app bar here
  final List<Widget>? actions; // Existing actions parameter
  final String title; // New title parameter

  const CustomAppBar({
    Key? key,
    this.preferredSize = const Size.fromHeight(60.0),
    this.actions,
    this.title = 'W Tracker', // Default value is 'W Tracker'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      actions: actions,
      elevation: 0, // This removes the shadow under the app bar.
      iconTheme: const IconThemeData(
          color: Colors.black), // This will make the back arrow visible
    );
  }
}
