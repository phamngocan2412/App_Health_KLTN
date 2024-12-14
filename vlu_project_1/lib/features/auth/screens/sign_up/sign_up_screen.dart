import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/components/login_signup_with_social.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/components/signin_signup_with.dart';
import 'package:vlu_project_1/features/auth/screens/sign_up/components/sign_up_form.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/app_bar_custom.dart';
import 'package:vlu_project_1/shared/widgets/sized_box.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSize.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  // Title
                  Text(
                    TText.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 40.h),
                  const SignUpForm(),
                  SizedBox(height: 40.h),
                  const SignInSignUpWith(dividerText: TText.orSignUpWith),
                  sh(20.h),
                  const LoginSignUpWithSocial(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
