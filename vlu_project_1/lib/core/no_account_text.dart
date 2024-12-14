import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/screens/sign_up/sign_up_screen.dart';
import 'package:vlu_project_1/shared/constants.dart';



class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Bạn chưa có tài khoản? ",
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16.sp,
          fontFamily: 'Poppins',
        ),
      ),
      TextButton(
        onPressed: () => Get.to(() => const SignUpScreen()),
        child: Text(
          "Đăng ký",
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 16.sp,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    ]);
  }
}
