import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/social_card.dart';
import 'package:vlu_project_1/features/auth/controller/sign_in_controller.dart';

class LoginSignUpWithSocial extends StatelessWidget {
  const LoginSignUpWithSocial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialCard(
          icon: "assets/icons/google.svg",
          press: () => controller.signinWithGoogle(),
        ),
        SocialCard(
          icon: "assets/icons/facebook.svg",
          press: () async => controller.signinWithFacebook(),
        ),
      ],
    );
  }
}
