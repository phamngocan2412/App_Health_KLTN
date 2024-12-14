import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/verify_email_controller.dart';
import 'package:vlu_project_1/shared/helper_functions.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/app_bar_custom.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: appBarCustom(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSize.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage("assets/images/verify_email.png"),
                width: HelperFunctions.screenWidth() * 0.6,
              ),

              // Title & SubTitle
              const Text(TText.confirmEmail,
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwItems),
              Text(email ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwItems),
              const Text(TText.confirmEmailSubTitle,
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () => controller.checkEmailVerificationStatus(),
                    child: const Text(TText.tcontinue)),
              ),

              const SizedBox(height: TSize.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: () => controller.sendEmailVerification(),
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
