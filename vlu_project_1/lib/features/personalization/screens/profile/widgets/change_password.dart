import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final UserController userController = Get.find();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(labelText: 'Password Cũ'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'Password Mới'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Nhập lại Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text != confirmPasswordController.text) {
                  Get.snackbar('Error', 'Passwords do not match');
                } else {
                  userController.changePassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  );
                }
              },
              child: const SizedBox(
                width: 100,
                height: 50,
                child: Center(child: Text('Thay đổi'))),
            ),
          ],
        ),
      ),
    );
  }
}
