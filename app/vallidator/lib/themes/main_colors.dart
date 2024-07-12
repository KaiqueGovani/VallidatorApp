import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainColors {
  static const Color primary = Color.fromRGBO(138, 244, 150, 1);
  static const Color tertiary = Color.fromRGBO(54, 150, 94, 1);
  static const Color activeGreen = Color.fromRGBO(19, 52, 32, 1);
  static const Color inactiveGreen = Color.fromRGBO(77, 156, 110, 1);
  static const Color uiGreen = Color.fromRGBO(142, 165, 160, 1);
  static const Color babyBlue = Color.fromRGBO(234, 254, 253, 1);
  static const Color babyGreen = Color.fromRGBO(180, 239, 204, 1);
  static const Color dangerRed = Color.fromRGBO(220, 53, 69, 1);
  static const Color disabledColor = Color.fromRGBO(222, 226, 230, 1);
  static const Color warningYellow = Color.fromRGBO(255, 250, 170, 1);
  static const Color warningYellowBorder = Color.fromRGBO(255, 193, 7, 1);

  static InputDecoration inputField = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 5.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static ButtonStyle successButton = ElevatedButton.styleFrom(
    minimumSize: const Size(200, 50),
    backgroundColor: tertiary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );

  static ButtonStyle warningButton = ElevatedButton.styleFrom(
    minimumSize: const Size(200, 50),
    backgroundColor: MainColors.warningYellow,
    foregroundColor: Colors.black.withOpacity(0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: BorderSide(
        color: MainColors.warningYellowBorder,
        width: 1,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );

  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    minimumSize: const Size(200, 50),
    backgroundColor: dangerRed,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );

  static ButtonStyle downloadButton = TextButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    backgroundColor: MainColors.babyGreen.withOpacity(0.27),
    foregroundColor: Colors.black.withOpacity(0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
      side: const BorderSide(
        color: MainColors.inactiveGreen,
        width: 1,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );

  static ButtonStyle useButton = TextButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
    foregroundColor: Colors.black.withOpacity(0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
      side: const BorderSide(
        color: Colors.black12,
        width: 1,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );

  static ButtonStyle editButton = TextButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black.withOpacity(0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
      side: const BorderSide(
        color: Colors.black54,
        width: 1,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );
}
