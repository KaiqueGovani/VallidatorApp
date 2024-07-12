import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/themes/main_colors.dart';

class StatusPill extends StatelessWidget {
  final bool? status;
  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: status == null
              ? MainColors.warningYellow
              : status!
                  ? MainColors.tertiary
                  : MainColors.babyGreen,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          status == null
              ? 'Pending'
              : status!
                  ? 'Active'
                  : 'Inactive',
          style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              color: status == true ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }
}
