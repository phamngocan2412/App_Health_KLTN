// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';



class LoginController extends GetxController {
  // Variables

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final emailSignIn = TextEditingController();
  final passwordSignIn = TextEditingController();
  final localStorage = GetStorage();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    emailSignIn.text = localStorage.read('remember_email') ?? '';
    passwordSignIn.text = localStorage.read('remember_password') ?? '';
    super.onInit();
  }

  // -- Email and Password Sign In
  Future<void> loginWithEmailAndPassword() async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
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
      if (!signInFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remembered is selected
      if (rememberMe.value) {
        localStorage.write('remember_email', emailSignIn.value.text.trim());
        localStorage.write(
            'remember_password', passwordSignIn.value.text.trim());
      }

      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(
              email: emailSignIn.value.text.trim(),
              password: passwordSignIn.value.text.trim());
      print('Đăng nhập thành công: ${userCredentials.user?.email}');

      AuthenticationRepository.instance.screenRedirect();
    } catch (error) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
      Get.offAll(() => const SignInScreen());
    }
  }

  Future<void> signinWithGoogle() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
      }

      // Google Authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      await userController.saveUserRecord(userCredentials);

      FullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (error) {
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
      Get.back();
    }
  }

  Future<void> signinWithFacebook() async {
    try {
      FullScreenLoader.openLoadingDialog("Đang tải ...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
      }

      // Google Authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithFacebook();

      await userController.saveUserRecord(userCredentials);

      FullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (error) {
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
      Get.back();
    }
  }
}
