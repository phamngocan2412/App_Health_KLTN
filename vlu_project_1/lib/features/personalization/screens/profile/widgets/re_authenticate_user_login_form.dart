import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';

class ReAuthenticateUserLoginForm extends StatelessWidget {
  const ReAuthenticateUserLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: _customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSize.defaultSpace),
          child: Form(
              key: controller.reAuthFormKey,
              child: _customColumn(controller)),
        ),
      ),
    );
  }

  Column _customColumn(UserController controller) {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.verifyEmail,
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
                  const SizedBox(height: TSize.spaceBtwInputField),

                  // Password
                  Obx(
                    () => TextFormField(
                      controller: controller.verifyPassword,
                      validator: (text) {
                        return Validate.pass(text, enableNullOrEmpty: false);
                      },
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye),
                            padding: const EdgeInsets.all(20),
                          ),
                          labelText: TText.password,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 70,
                            minHeight: 60,
                          )),
                    ),
                  ),
                  const SizedBox(height: TSize.spaceBtwSections),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () =>
                            controller.reAuthenticateEmailAndPasswordUser(),
                        child: const Text('Xác thực')),
                  )
                ]);
  }

  AppBar _customAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Xác thực lại người dùng'),
      elevation: 2,
      shadowColor: Colors.black,
      centerTitle: true,
    );
  }
}
