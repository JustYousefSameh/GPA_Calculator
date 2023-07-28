import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary100 = Colors.white;
// const primary100 = Color(0xFFEAEFFC);
const primary200 = Color(0xFF4A9292);
const primary300 = Color(0xFF046865);
const secondary300 = Color(0xFF03045E);

TextStyle elevatedButtonTextStyle = GoogleFonts.lato(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.normal,
);

ThemeData customTheme = ThemeData(
  scaffoldBackgroundColor: primary100,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: primary100,
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
  ),
  textTheme: GoogleFonts.cairoTextTheme().copyWith(
    labelLarge: GoogleFonts.rubik(
      fontSize: 18,
      color: primary300,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.rubik(
      fontSize: 24,
      color: secondary300,
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 50)))),
  appBarTheme: const AppBarTheme(
    foregroundColor: primary100,
    backgroundColor: primary100,
    elevation: 0,
  ),
);
