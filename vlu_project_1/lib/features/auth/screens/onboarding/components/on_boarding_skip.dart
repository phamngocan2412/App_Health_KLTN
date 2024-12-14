import 'package:flutter/material.dart';
import 'package:vlu_project_1/features/auth/controller/onboarding_controller.dart';
import 'package:vlu_project_1/shared/size.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: TSize.defaultSpace,
      top: 20,
      child: SafeArea(
        child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
            onPressed: () => OnboardingController.instance.skipPage(),
            child: const Text('Skip')),
      ),
    );
  }
}
