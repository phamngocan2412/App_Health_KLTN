import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/terms_conditions_checkbox.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/auth/controller/sign_up_controller.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}
class SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signUpFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // First Name & Last Name Row
          Row(
            children: [
              // First Name
              Expanded(
                child: TextFormField(
                controller: controller.firstName,
                validator: (text) {
                  return Validate.firstName(text, enableNullOrEmpty: false);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user),
                  labelText: TText.firstName,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
              ),

              ),
              const SizedBox(width: 10),
              // Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (text) {
                    return Validate.lastName(text, enableNullOrEmpty: false);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.user_minus),
                    labelText: TText.lastName,
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
                ),
              ),
            ],
          ),
          const SizedBox(height: TSize.spaceBtwInputField),

          // Username
          TextFormField(
            controller: controller.userName,
            validator: (text) {
              return Validate.userName(text, enableNullOrEmpty: false);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.user_edit),
              labelText: TText.userName,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
          ),
          const SizedBox(height: TSize.spaceBtwInputField),

          // Email
          TextFormField(
            controller: controller.emailSignUp,
            validator: (text) {
              return Validate.email(text, enableNullOrEmpty: false);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.direct),
              labelText: TText.email,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
          ),
          const SizedBox(height: TSize.spaceBtwInputField),

          // Phone
          TextFormField(
            controller: controller.phoneNumber,
            validator: (text) {
              return Validate.phone(text, enableNullOrEmpty: false);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.call),
              labelText: TText.phoneNumber,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
          ),
          const SizedBox(height: TSize.spaceBtwInputField),

          // Password
          Obx(
            () => TextFormField(
              controller: controller.passwordSignUp,
              validator: (text) {
                return Validate.pass(text, enableNullOrEmpty: false);
              },
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TText.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: controller.hidePassword.value
                      ? const Icon(Iconsax.eye_slash)
                      : const Icon(Iconsax.eye),
                  padding: const EdgeInsets.all(20),
                ),
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
            ),
          ),
          const SizedBox(height: TSize.spaceBtwSections),

          // Terms & Privacy checkbox
          const TermsConditionsCheckbox(),

          const SizedBox(height: TSize.spaceBtwSections),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              child: const Text(TText.createAccount),
              onPressed: () {
                controller.signUp();
              },
            ),
          ),
        ],
      ),
    );
  }
}
