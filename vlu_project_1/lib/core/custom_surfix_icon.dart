import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    super.key,
    required this.svgIcon,
    required this.onPressed,
  });

  final String svgIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: IconButton(
        icon: SvgPicture.asset(
          svgIcon,
          height: 30.h,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class PasswordVisibilityIcon extends StatefulWidget {
  const PasswordVisibilityIcon({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  PasswordVisibilityIconState createState() => PasswordVisibilityIconState();
}

class PasswordVisibilityIconState extends State<PasswordVisibilityIcon> {
  bool _isObscured = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: IconButton(
        icon: SvgPicture.asset(
          _isObscured ? 'assets/icons/eye_close.svg' : 'assets/icons/eye.svg',
          height: 30.h,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
          widget.onToggle(); // Gọi hàm callback từ widget cha
        },
      ),
    );
  }
}
