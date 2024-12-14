import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/forget_password_controller.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:vlu_project_1/shared/helper_functions.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/app_bar_custom.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image(
                image: const AssetImage("assets/images/reset_password.png"),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              const Text(TText.changeYourPasswordTitle,
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwItems),
              const Text(TText.changeYourPasswordSubTitle,
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const SignInScreen()),
                  child: const Text(TText.done),
                ),
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: () => ForgetPasswordController.instance
                      .resendPasswordResentEmail(email),
                  child: const Text(TText.resendEmail),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
