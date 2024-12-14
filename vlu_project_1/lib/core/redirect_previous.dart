import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedirectToPreviousScreen extends StatelessWidget {
  const RedirectToPreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Get.back();
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
