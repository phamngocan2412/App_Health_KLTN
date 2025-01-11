import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/auth/controller/sign_in_controller.dart';
import 'package:vlu_project_1/features/auth/screens/forgot_password/forgot_password_screen.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.signInFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction, 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSize.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: controller.emailSignIn,
              validator: (text) {
                return Validate.email(text, enableNullOrEmpty: false);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: TText.email,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 70,
                  minHeight: 60,
                ),
              ),
              onChanged: (_) {
                setState(() {}); 
              },
            ),
            const SizedBox(height: TSize.spaceBtwInputField),

            // Password
            Obx(
              () => TextFormField(
                controller: controller.passwordSignIn,
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
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black54),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red), 
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 70,
                      minHeight: 60,
                    )),
                onChanged: (_) {
                  setState(() {}); 
                },
              ),
            ),
            const SizedBox(height: TSize.spaceBtwInputField / 2),

            // Remember me & forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Remember me
                Obx(
                  () => Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (value) => controller.rememberMe.value =
                        !controller.rememberMe.value,
                  ),
                ),
                const Text(TText.rememberMe),
                const Spacer(),

                // Forgot password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                  child: const Text(TText.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSize.spaceBtwSections),

            // Sign in button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => controller.loginWithEmailAndPassword(),
                child: const Text(TText.signIn),
              ),
            ),
            const SizedBox(height: TSize.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
