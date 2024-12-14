// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:vlu_project_1/core/services/medicine_statistic_page.dart';

import 'features/auth/screens/forgot_password/forgot_password_screen.dart';
import 'features/auth/screens/onboarding/onboarding_screen.dart';
import 'features/auth/screens/sign_in/sign_in_screen.dart';
import 'features/auth/screens/sign_up/sign_up_screen.dart';
import 'features/auth/screens/verify_email/verify_email_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/medicien/screens/medicien_screen.dart';
import 'features/medicien/screens/widgets/medicien_json.dart';
import 'features/personalization/screens/profile/profile_screen.dart';
import 'shared/navigation_menu.dart';


class TRoutes {
  static const String onBoard = '/onboarding';
  static const String signUp = '/sign-up';
  static const String login = '/login';
  static const String forgetPassword = '/forget-password';
  static const String navigationMenu = '/navigation-menu';
  static const String medicine = '/medicine';
  static const String profile = '/profile';
  static const String verifyEmail = '/verify-email';
  static const String home = '/home';
  static const String resetPassword = '/reset-password';
  static const String medicineJson = '/medicine-json';
  static const String medicineStatisticPage = '/medicine-statistic-page';
}

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.onBoard, page: () => const OnboardingScreen()),
    GetPage(name: TRoutes.signUp, page: () => const SignUpScreen()),
    GetPage(name: TRoutes.login, page: () => const SignInScreen()),
    GetPage(
        name: TRoutes.forgetPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: TRoutes.navigationMenu, page: () => const NavigationMenu()),
    GetPage(name: TRoutes.medicine, page: () => const MedicineScreen()),
    GetPage(name: TRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    GetPage(name: TRoutes.medicineJson, page: () => const MedicineJson()),
    GetPage(name: TRoutes.medicineStatisticPage, page: () => const MedicineStatisticsPage())
  ];
}
