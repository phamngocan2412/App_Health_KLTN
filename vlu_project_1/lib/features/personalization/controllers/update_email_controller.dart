// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';

class UpdateEmailController extends GetxController {
  static UpdateEmailController get instance => Get.find();

  final email = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  final authRepository = Get.put(AuthenticationRepository());
  final GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializedEmail();
    super.onInit();
  }

  Future<void> initializedEmail() async {
    email.text = userController.user.value.email;
  }

  Future<void> updateEmail() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
        return;
      }

      if (!updateEmailFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }
      final emailExists = await authRepository.checkEmailExists(email.text.trim());
      if (emailExists) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Email đã tồn tại trong hệ thống');
        FullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> data = {
        'Email': email.text.trim(),
      };
      await userRepository.updateSingleField(data);
      userController.user.value.email = email.text.trim();
      await authRepository.sendEmailVerification();

      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: 'Thành công', message: 'Cập nhật email thành công. Vui lòng kiểm tra email của bạn để xác thực.');

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }
}