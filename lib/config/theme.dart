import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData defaultTheme(BuildContext context) {
  return ThemeData(
    // ===== GLOBAL =====
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    // ===== INPUT TEXTFIELD =====
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
      prefixIconColor: Colors.black54,
      suffixIconColor: Colors.black54,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
    ),

    // ===== APP BAR =====
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black45,
      centerTitle: false,
      iconTheme: IconThemeData(color: primary),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),

    // ===== BUTTON =====
    buttonTheme: ButtonThemeData(
      buttonColor: primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      textTheme: ButtonTextTheme.primary,
    ),

    // ===== COLOR SCHEME =====
    colorScheme: ColorScheme.light().copyWith(
      primary: HexColor('#2390d2'),
      secondary: HexColor('#c43368'),
      surface: Colors.white,
      onSurface: Colors.black87,
      background: Colors.white,
      onBackground: Colors.black87,
      error: Colors.red[800],
      onPrimary: Colors.white,
    ),
    
    // ===== TEXT THEME =====
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
    ),
  );
}

Color primary = HexColor('#0070c6');
Color secondary = HexColor('#e2477f');
// Color primary2 = HexColor('#f2d4a0');
Color success = HexColor('#00b300');
Color danger = HexColor('#cc0000');
Color warning = HexColor('#FFCA00');
Color info = HexColor('#1992ff');
Color theme = Colors.white;

Color textTheme = Colors.black; 