import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInSignUpWith extends StatelessWidget {
  const SignInSignUpWith({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(color: Colors.grey[500]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dividerText,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.sp,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[500]),
        ),
      ],
    );
  }
}
