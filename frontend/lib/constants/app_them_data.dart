import 'package:flutter/material.dart';

class AppThemeData {
  AppThemeData._();
  static final ThemeData lightTheme = ThemeData(
    // scaffoldBackgroundColor: const Color(0xffF3EAE1),

    primaryColor: const Color(0xffF67552),
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xffF67552),
      secondary: const Color(0xffCCAB9D),
    ),

    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black,
    ),

    fontFamily: "Inter",

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      headlineSmall : TextStyle(
        color: Colors.black,
      ),
      titleLarge : TextStyle(
        color: Colors.black,
      ),
      bodyLarge : TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium : TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ).apply(displayColor: Colors.black),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xffF67552),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xffF67552),
      secondary: const Color(0xffCCAB9D),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    fontFamily: "Inter",
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall : TextStyle(),
      titleLarge : TextStyle(),
      bodyLarge : TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium : TextStyle(
        fontSize: 14,
      ),
    ).apply(displayColor: Colors.white),
  );
}
