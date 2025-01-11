// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/gender_selector.dart';
import '../../controllers/update_gender_controller.dart';

class GenderUpdateScreen extends StatelessWidget {
  final UpdateGenderController profileController = Get.put(UpdateGenderController());

  GenderUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), 
      child: SingleChildScrollView(
        child: Column(
          children: [
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
