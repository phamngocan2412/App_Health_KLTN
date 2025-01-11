// ignore: depend_on_referenced_packages
// ignore_for_file: avoid_print
// ignore: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';

class UpdateGenderController extends GetxController {
  RxString userGender = "Chưa chọn".obs;
  final GlobalKey<FormState> updateGenderFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    loadGenderFromPreferences();
    super.onInit();
  }

  void updateGender(String newGender) {
    userGender.value = newGender;
  }

  Future<void> saveProfile() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
        return;
      }
      await saveGenderToPreferences(userGender.value);

      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(title: 'Thành công', message: 'Cập nhật thông tin thành công.');

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  Future<void> saveGenderToPreferences(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_gender', gender);
  }

  Future<void> loadGenderFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString('user_gender');
    if (gender != null) {
      userGender.value = gender;
    } else {
      print("Không tìm thấy giới tính trong SharedPreferences, sử dụng mặc định.");
    }
  }
}
