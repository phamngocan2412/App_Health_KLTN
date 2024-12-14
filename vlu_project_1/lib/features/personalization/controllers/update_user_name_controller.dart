import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/profile_screen.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';

class UpdateUserNameController extends GetxController {
  static UpdateUserNameController get instance => Get.find();

  final username = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializedUsername();
    super.onInit();
  }

  Future<void> initializedUsername() async {
    username.text = userController.user.value.username; // Khởi tạo giá trị username
  }

  Future<void> updateUserName() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Update username in Firebase Firestore
      Map<String, dynamic> data = {
        'Username': username.text.trim(),
      };
      await userRepository.updateSingleField(data);

      // Update the Rx User value
      userController.user.value.username = username.text.trim();

      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: 'Thành công', message: 'Cập nhật tên người dùng thành công');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }
}