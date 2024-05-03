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

    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black,
    ),

    fontFamily: "Inter",

    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      headline5: TextStyle(
        color: Colors.black,
      ),
      headline6: TextStyle(
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: TextStyle(
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
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    fontFamily: "Inter",
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headline3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headline5: TextStyle(),
      headline6: TextStyle(),
      bodyText1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
      ),
    ).apply(displayColor: Colors.white),
  );
}
