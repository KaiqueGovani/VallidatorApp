import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/themes/main_colors.dart';

ThemeData mainTheme = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: MainColors.primary,
    textTheme: TextTheme(
      labelLarge: TextStyle(
        fontSize: 20,
        fontFamily: GoogleFonts.inter().fontFamily,
        color: MainColors.activeGreen,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.inter().fontFamily,
        color: MainColors.tertiary,
      ),
      headlineMedium: TextStyle(
        color: MainColors.activeGreen,
        fontSize: 36,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.7,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(
        color: MainColors.activeGreen,
        fontSize: 16,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.bold,
      ),
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black38,
          width: 0.9,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: MainColors.uiGreen,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black38,
          width: 0.9,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: MainColors.tertiary,
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: GoogleFonts.inter().fontFamily,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          )),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: MainColors.primary,
      foregroundColor: MainColors.tertiary,
      titleTextStyle: TextStyle(
        color: MainColors.activeGreen,
        fontSize: 20,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: MainColors.activeGreen,
      ),
    ),
    scaffoldBackgroundColor: MainColors.babyBlue,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MainColors.babyGreen,
      foregroundColor: MainColors.activeGreen,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MainColors.activeGreen,
    ));
