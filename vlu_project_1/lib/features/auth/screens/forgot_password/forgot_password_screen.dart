// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/auth/controller/forget_password_controller.dart';
import 'package:vlu_project_1/shared/helper_functions.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/app_bar_custom.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: appBarCustom(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/forgot1.png"),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              Text(
                TText.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              Text(TText.forgetPasswordSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSize.spaceBtwSections),
              // Text Field
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
                  validator: (text) {
                    return Validate.email(text, enableNullOrEmpty: false);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: TText.email,
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
              ),
              const SizedBox(height: TSize.spaceBtwSections),

              // Submit Button
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.sendPasswordResentEmail(),
                  child: const Text(TText.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
