import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/onboarding_controller.dart';
import 'package:vlu_project_1/features/auth/screens/onboarding/components/on_boarding_dot_navigation.dart';
import 'package:vlu_project_1/features/auth/screens/onboarding/components/on_boarding_next_button.dart';
import 'package:vlu_project_1/features/auth/screens/onboarding/components/on_boarding_page.dart';
import 'package:vlu_project_1/features/auth/screens/onboarding/components/on_boarding_skip.dart';
import 'package:vlu_project_1/shared/widgets/image_strings.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: const [
                OnBoardingPage(
                  image: TImage.image1,
                  title: TText.title1,
                  subTitle: TText.subtitle1,
                ),
                OnBoardingPage(
                  image: TImage.image2,
                  title: TText.title2,
                  subTitle: TText.subtitle2,
                ),
                OnBoardingPage(
                  image: TImage.image3,
                  title: TText.title3,
                  subTitle: TText.subtitle3,
                ),
              ],
            ),
            const OnBoardingSkip(),
            const OnBoardingDotNavigation(),
            const OnBoardingNextButton(),
          ],
        ),
      ),
    );
  }
}
