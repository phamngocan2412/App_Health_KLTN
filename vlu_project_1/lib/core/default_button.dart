import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlu_project_1/shared/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
  });

  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(kPrimaryColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.h),
            ),
          ),
        ),
        onPressed: press,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
