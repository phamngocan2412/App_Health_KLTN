import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/sign_in_screen.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  // Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  // Jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Update Current Index & jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();
      storage.write('isFirstTime', false);
      Get.offAll(() => const SignInScreen());
    } else {
      int page = currentPageIndex.value + 1;
      currentPageIndex.value = page;
      pageController.jumpToPage(page);
    }
  }

  // Update Current Index & jump to last page
  void skipPage() {
    Get.off(() => const SignInScreen());
  }
}
