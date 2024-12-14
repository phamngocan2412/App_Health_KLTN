// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vlu_project_1/core/utils/network.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/models/user_model.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';
import 'package:image_picker/image_picker.dart';


class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final userRepository = Get.put(UserRepository());
  final hidePassword = true.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // Refresh User Record
      await fetchUserRecord();

      // If no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and last name
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      Loaders.warningSnackBar(
          title: 'Dữ liệu không đươc lưu lại.',
          message:
              'Có gì đó không chính xáv trong khi lưu trữ thông tin. Bạn có thể lưu lại dữ liệu trong Hồ sơ của bạn.');
    }
  }

  // Delete Account Warning Popup
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      radius: 40,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      middleText: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 80,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          const Text(
            'Xóa tài khoản',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bạn có chắc chắn muốn xóa tài khoản không? Hành động này không thể hoàn tác.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54, // Màu sắc trung tính cho phần mô tả
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(Get.overlayContext!).pop(),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: BorderSide(color: Colors.grey.shade400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async => deleteUserAccount(),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor:
                      Colors.redAccent, // Màu đỏ nổi bật cho nút xóa
                  elevation: 0,
                ),
                child: const Text(
                  'Xóa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Delete User Account
  void deleteUserAccount() async {
    try {
      FullScreenLoader.openLoadingDialog('Đang xóa ...');

      // First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          FullScreenLoader.stopLoading();
          Get.offAll(() => const SignInScreen());
        } else if (provider == 'password') {
          FullScreenLoader.stopLoading();
          Get.to(() => const ReAuthenticateUserLoginForm());
        }
      }
    } catch (error) {
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
    }
  }

  // Re-Authenticate User
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      FullScreenLoader.openLoadingDialog('Đang xử lý ...');

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không có kết nối Internet');
        FullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();

      FullScreenLoader.stopLoading();

      Get.offAll(() => const SignInScreen());
    } catch (error) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
    }
  }

  // Upload Profile Picture
  Future<String> uploadImageToNodeServer(XFile imageFile) async {
    final url = Uri.parse('http://192.168.1.9:8000/upload');
    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      return responseData['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        final imageUrl = await uploadImageToNodeServer(image);

        // Cập nhật ảnh người dùng
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);
        user.value.profilePicture = imageUrl;

        Loaders.successSnackBar(
            title: 'Xin chúc mừng', message: 'Thay đổi ảnh cá nhân thành công');

        user.refresh();
      }
    } catch (error) {
      Loaders.errorSnackBar(title: 'Lỗi', message: error.toString());
    }
  }
}
