import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlu_project_1/core/no_account_text.dart';
import 'package:vlu_project_1/core/utils/assets/assets.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/components/login_signup_with_social.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/components/sign_in_form.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/components/signin_signup_with.dart';
import 'package:vlu_project_1/shared/constants.dart';
import 'package:vlu_project_1/shared/widgets/sized_box.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';



class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Assets.img.loginBg
                      .build(width: double.infinity, fit: BoxFit.cover),
                  Container(
                      margin: EdgeInsets.only(top: 130.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 35.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          sh(48.h),
                          Assets.img.logo.build(
                            height: 88.h,
                            width: 266.w,
                          ),
                          const Divider(
                            color: Colors.black87,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          sh(20.h),
                          Text(
                            TText.loginTitle,
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            TText.loginSubTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          sh(42.h),
                          const SignForm(),
                          sh(10.h),
                          const SignInSignUpWith(
                              dividerText: TText.orSignInWith),
                          sh(20.h),
                          const LoginSignUpWithSocial(),
                          sh(30.h),
                          const NoAccountText(),
                          sh(30.h),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
