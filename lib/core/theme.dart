import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary100 = Colors.white;
const primary200 = Color(0xFF4A9292);
const primary300 = Color(0xFF003566);
const secondary300 = Color(0xFF001D3D);

ThemeData customTheme = ThemeData(
  scaffoldBackgroundColor: primary100,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: primary100,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    labelLarge: GoogleFonts.rubik(
      fontSize: 18,
      color: secondary300,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.rubik(
      fontSize: 26,
      color: primary300,
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: primary100,
    elevation: 0,
  ),
);
