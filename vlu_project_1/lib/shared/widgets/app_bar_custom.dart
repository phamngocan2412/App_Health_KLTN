import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

appBarCustom() {
    return AppBar(
      backgroundColor: Colors.grey[100],
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Image.asset(
        'assets/images/logo.png',
        height: 30,
      ),
      centerTitle: true,
    );
  }