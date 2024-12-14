import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/shared/widgets/animation_loader.dart';



class FullScreenLoader {
  static void openLoadingDialog(String text, {String? animation}) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // Prevent dialog from being dismissed
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              AnimationLoaderWidget(
                text: text,
                animation: animation ??
                    'assets/images/animation_loader.gif', // Use default if not provided
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
