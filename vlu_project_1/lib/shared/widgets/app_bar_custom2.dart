import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';


class AppBarCustom2 extends StatelessWidget {
  const AppBarCustom2({
    super.key, required this.title,
  });

  final Text title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: title,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }
}
