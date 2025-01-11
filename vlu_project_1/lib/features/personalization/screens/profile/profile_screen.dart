// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/gender_update_screen.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/change_email.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/change_phone.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/date_of_birth_selector.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/change_user_name.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/t_circular_image.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';
import 'package:vlu_project_1/shared/widgets/section_heading.dart';
import 'package:vlu_project_1/shared/widgets/shimmer.dart';
import '../../controllers/update_gender_controller.dart';
import 'widgets/change_password.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateGenderController profileController = Get.put(UpdateGenderController());
    final controller = UserController.instance;
    profileController.loadGenderFromPreferences();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 30,
        ),
        elevation: 2,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => _showLogoutConfirmation(context),
            color: Colors.redAccent,
            iconSize: 28,
            tooltip: 'Logout',
            padding: const EdgeInsets.all(10),
            splashRadius: 28,
            splashColor: Colors.grey.withOpacity(0.2),
            hoverColor: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSize.defaultSpace),
        child: Column(
          children: [
            // Profile Picture Section
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : 'assets/images/avatar_default.png';
                    return controller.profileLoading.value
                        ? const TShimmer(width: 80, height: 80)
                        : TCircularImage(
                            image: image,
                            width: 80,
                            height: 80,
                            isNetWorkImage: networkImage.isNotEmpty,
                          );
                  }),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () => controller.uploadUserProfilePicture(),
                    child: const Text(
                      'Thay đổi ảnh',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),

            // Profile Info Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const TSectionHeading(
                      title: 'Thông tin cá nhân',
                      showActionButton: false,
                    ),
                    Obx(() => ProfileMenu(
                      title: 'Tên',
                      value: controller.user.value.fullName,
                      onPressed: () => Get.to(
                        () => const ChangeName(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      ),
                    )),
                    Obx(() => ProfileMenu(
                      title: 'Tên người dùng',
                      value: controller.user.value.username,
                      onPressed: () => Get.to(
                        () => const ChangeUsername(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            const Divider(),
            const SizedBox(height: 20),

            // User Info Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const TSectionHeading(
                      title: 'Thông tin người dùng',
                      showActionButton: false,
                    ),
                    ProfileMenu(
                      title: 'User ID',
                      value: controller.user.value.id,
                      icon: Iconsax.copy,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.user.value.id));
                        Loaders.successSnackBar(title: "Thông báo", message: 'Đã sao chép User ID vào clipboard');
                      },
                    ),
                    Obx(() => ProfileMenu(
                      title: 'E-mail',
                      value: controller.user.value.email,
                      onPressed: () => Get.to(
                        () => const ChangeEmail(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      ),
                    )),
                    Obx(() => ProfileMenu(
                      title: 'Số điện thoại',
                      value: controller.user.value.phoneNumber.isEmpty
                          ? "Chưa nhập"
                          : controller.user.value.formattedPhoneNumber,
                      onPressed: () => Get.to(
                        () => const ChangePhoneNumber(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      ),
                    )),
                    Obx(() => ProfileMenu(
                      title: 'Giới tính',
                      value: profileController.userGender.value.isNotEmpty
                          ? profileController.userGender.value
                          : "Chưa nhập",
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Container(
                          height: 300,
                          padding: const EdgeInsets.all(20),
                          child: GenderUpdateScreen(),
                        ),
                      ),
                    )),
                    // Nút đổi mật khẩu
                    ProfileMenu(
                      title: 'Mật khẩu',
                      value: '********',
                      onPressed: () => Get.to(
                        () => ChangePasswordScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ),

                    const DateOfBirthSelector(),
                  ],
                ),
              ),
            ),

            const Divider(),
            const SizedBox(height: 20),

            // Delete Account Section
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.all(16),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () => controller.deleteAccountWarningPopup(),
                child: const Text(
                  'Xóa tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                AuthenticationRepository.instance.logout();
              },
              child: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
