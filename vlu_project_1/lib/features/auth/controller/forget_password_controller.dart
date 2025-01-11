import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/features/auth/screens/reset_password/reset_password.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';



class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  final email = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      FullScreenLoader.openLoadingDialog(
        "Đang tải ...",
      );

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: "Lỗi", message: "Không có kết nối internet.");
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: "Lỗi", message: "Vui lòng kiểm tra lại thông tin.");
        return;
      }

      // Kiểm tra email tồn tại
      bool emailExists = await AuthenticationRepository.instance
          .checkEmailExists(email.text.trim());

      if (!emailExists) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: "Lỗi", message: "Email không tồn tại trong hệ thống.");
        return;
      }

      // Gửi email đặt lại mật khẩu
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email: email.text.trim());

      // Stop Loading
      FullScreenLoader.stopLoading();

      // Show Success Screen
      Loaders.successSnackBar(
          title: "Thành công",
          message: "Đã gửi đến Email của bạn, hãy làm mới mật khẩu.");

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
      FullScreenLoader.stopLoading();
    }
  }

  // resendPasswordResentEmail
  resendPasswordResentEmail(String email) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog("Đang tải...");

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: "Lỗi", message: "Không có kết nối internet.");
        return;
      }

      FullScreenLoader.stopLoading();
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email: email);
      Loaders.successSnackBar(
          title: "Thành công",
          message: "Đã gửi đến Email của bạn, hãy làm mới mật khẩu.");
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
      FullScreenLoader.stopLoading();
    }
  }
}
