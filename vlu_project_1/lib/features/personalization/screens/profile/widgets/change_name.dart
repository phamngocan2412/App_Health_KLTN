import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/personalization/controllers/update_name_controller.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
        // Custom AppBar
        appBar: _customAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(TSize.defaultSpace),
          child: SingleChildScrollView(
            child: _customColumn(controller),
          ),
        ));
  }

  Column _customColumn(UpdateNameController controller) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwInputField),
              Form(
                key: controller.updateUserNameFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.lastName,
                      validator: (text) {
                        return Validate.lastName(text,
                            enableNullOrEmpty: false);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: TText.lastName,
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
                    const SizedBox(height: TSize.spaceBtwInputField),
                    TextFormField(
                      controller: controller.firstName,
                      validator: (text) {
                        return Validate.firstName(text,
                            enableNullOrEmpty: false);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: TText.firstName,
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
                  ],
                ),
              ),
              const SizedBox(height: TSize.spaceBtwSections),
              const SizedBox(height: TSize.spaceBtwSections),
              // Update button
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
        title: const Text('Thay đổi tên'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      );
  }
}
