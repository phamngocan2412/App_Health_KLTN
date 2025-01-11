import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/models/user_model.dart';
import 'package:vlu_project_1/features/auth/screens/verify_email/verify_email_screen.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final privacyPolicy = true.obs;
  final hidePassword = true.obs;
  final emailSignUp = TextEditingController();
  final passwordSignUp = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final phoneNumber = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      try {
        // Start Loading
        FullScreenLoader.openLoadingDialog("Đang tải ...");

        // Check Internet Connectivity
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          Loaders.errorSnackBar(
              title: 'Lỗi', message: 'Không có kết nối Internet');
          return;
        }

        // Form Validation
        if (!signUpFormKey.currentState!.validate()) {
          FullScreenLoader.stopLoading();
          return;
        }

        // Privacy Policy Validation
        if (!privacyPolicy.value) {
          FullScreenLoader.stopLoading();
          Loaders.warningSnackBar(
              title: 'Đồng ý với điều kiện bảo mật ',
              message:
                  'Bạn cần đồng ý với Chính sách bảo mật & Điều khoản sử dụng');
          return;
        }

        // Register User Firebase
        final userCredential = await AuthenticationRepository.instance
            .registerWithEmailAndPassword(
                email: emailSignUp.text.trim(),
                password: passwordSignUp.text.trim());

        final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: userName.text.trim(),
          email: emailSignUp.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
        );

        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newUser);

        FullScreenLoader.stopLoading();
        Loaders.successSnackBar(
            title: 'Chúc mừng',
            message: 'Tài khoản đã được tạo thành công! Hãy kiểm tra email.');

        if (Get.context != null) {
          Get.to(() => VerifyEmailScreen(email: emailSignUp.text.trim()));
        }
      } catch (error) {
        Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
        FullScreenLoader.stopLoading();
      }
    }
  }
}
