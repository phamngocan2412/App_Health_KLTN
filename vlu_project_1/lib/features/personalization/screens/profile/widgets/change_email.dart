import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/personalization/controllers/update_email_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/shared/size.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSize.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: controller.updateEmailFormKey,
            child: _customColumn(controller),
          ),
        ),
      ),
    );
  }

  Column _customColumn(UpdateEmailController controller) {
    return Column(
            children: [
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwInputField),
              TextFormField(
                controller: controller.email,
                validator: (text) {
                  return Validate.email(text, enableNullOrEmpty: false);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
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
                  onPressed: controller.updateEmail,
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
      title: const Text('Thay đổi email'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }
}
