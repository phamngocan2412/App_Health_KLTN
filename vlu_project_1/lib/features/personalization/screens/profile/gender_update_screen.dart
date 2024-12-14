import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/features/personalization/controllers/update_gender_controller.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/gender_selector.dart';

class GenderUpdateScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  GenderUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Padding tùy chọn
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Tiêu đề nếu cần
            const Text(
              "Thay đổi giới tính",
              style: TextStyle(fontSize: 20,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10), 
            GenderSelector(
              initialValue: profileController.userGender.value,
              onValueChanged: (newGender) {
                profileController.updateGender(newGender);
                profileController.saveGenderToPreferences(newGender);
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
