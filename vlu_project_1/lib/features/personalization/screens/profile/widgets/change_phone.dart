// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/personalization/controllers/update_phone_controller.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/shared/size.dart';

class ChangePhoneNumber extends StatelessWidget {
  const ChangePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePhoneNumberController());
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSize.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: controller.updatePhoneNumberFormKey,
            child: _customColumn(controller),
          ),
        ),
      ),
    );
  }

  Column _customColumn(UpdatePhoneNumberController controller) {
    return Column(
            children: [
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwInputField),
              TextFormField(
                controller: controller.phoneNumber,
                validator: (text) {
                  return Validate.phone(text, enableNullOrEmpty: false);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Số điện thoại',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: controller.updatePhoneNumber,
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
      title: const Text('Thay đổi số điện thoại'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }
}
