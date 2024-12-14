import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryLightColor = Color(0xFF6439FF);
const kPrimaryColor = Color(0xFF4F75FF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF649CF8), Color(0xFF0055B1)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);
