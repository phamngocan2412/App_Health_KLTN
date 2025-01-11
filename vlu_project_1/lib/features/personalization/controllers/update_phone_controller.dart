// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';

class UpdatePhoneNumberController extends GetxController {
  static UpdatePhoneNumberController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> updatePhoneNumberFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializedPhoneNumber();
    super.onInit();
  }

  Future<void> initializedPhoneNumber() async {
    phoneNumber.text = userController.user.value.phoneNumber;
  }

  Future<void> updatePhoneNumber() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
        return;
      }

      if (!updatePhoneNumberFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Update phone number in Firebase Firestore
      Map<String, dynamic> data = {
        'PhoneNumber': phoneNumber.text.trim(),
      };
      await userRepository.updateSingleField(data);

      userController.user.value.phoneNumber = phoneNumber.text.trim();
      userController.user.refresh();
      
      Get.back();
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: 'Thành công', message: 'Cập nhật số điện thoại thành công');

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }
}
