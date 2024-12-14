import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlu_project_1/features/auth/controller/onboarding_controller.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
      bottom: 70.h,
      left: TSize.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 3,
        onDotClicked: controller.dotNavigationClick,
        effect: const ExpandingDotsEffect(
          dotWidth: 6,
          dotHeight: 6,
          dotColor: Colors.grey,
          activeDotColor: Colors.blue,
          expansionFactor: 3,
          spacing: 5,
        ),
      ),
    );
  }
}
