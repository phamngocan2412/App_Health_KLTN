// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vlu_project_1/shared/constants.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);


ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(),
    textTheme: const TextTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: kTextColor,
  );

  static const TextStyle dateText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );

  static const TextStyle dayText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );

  static const TextStyle monthText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );


}

TextStyle get headingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.bold),
    );
TextStyle get subHeadingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
TextStyle get titleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
TextStyle get subTitleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
TextStyle get bodyStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400),
    );
TextStyle get body2Style => GoogleFonts.lato(
      textStyle: TextStyle(
          color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400),
    );

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: kTextColor,
    ),
  );
}
