import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/validate.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/features/personalization/controllers/update_user_name_controller.dart';
import 'package:vlu_project_1/shared/size.dart';


class ChangeUsername extends StatelessWidget {
  const ChangeUsername({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateUserNameController());
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSize.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: controller.updateUserNameFormKey,
            child: _customColumn(controller),
          ),
        ),
      ),
    );
  }

  Column _customColumn(UpdateUserNameController controller) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwInputField),
              TextFormField(
                controller: controller.username,
                validator: (text) {
                  return Validate.userName(text, enableNullOrEmpty: false);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  labelText: 'Tên',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 70,
                    minHeight: 60,
                  ),
                ),
              ),
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: controller.updateUserName,
                  child: const Text('Cập nhật'),
                ),
              ),
            ],
          );
  }

  AppBar _customAppBar() {
    return AppBar(
      elevation: 2,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Thay đổi tên người dùng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      );
  }
}