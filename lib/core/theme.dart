import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary100 = Colors.white;

// const primary100 = Color(0xFFEAEFFC);
const primary200 = Color(0xFF4A9292);
// const primary300 = Color(0xFF046865);250, 225, 223
// const primary300 = Color.fromRGBO(250, 225, 223, 1);
const primary300 = Color(0xFF003566);
// const secondary300 = Color(0xFF03045E);
const secondary300 = Color(0xFF001D3D); //the darker one

class TopBottomInputBorder extends UnderlineInputBorder {
  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(bottom: borderSide.width, top: borderSide.width);
  }
}

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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 50)))),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: primary100,
    elevation: 0,
  ),
);
