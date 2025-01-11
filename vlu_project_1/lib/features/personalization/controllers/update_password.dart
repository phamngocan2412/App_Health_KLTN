import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final UserController userController = Get.find();

  final TextEditingController passwordController = TextEditingController();

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password mới'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                userController.updatePassword(passwordController.text);
              },
              child: const Text('Cập nhật Password'),
            ),
          ],
        ),
      ),
    );
  }
}
