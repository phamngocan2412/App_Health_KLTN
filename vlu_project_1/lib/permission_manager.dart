import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // Kiểm tra và yêu cầu quyền Camera
  static Future<void> checkAndRequestCameraPermission(BuildContext context) async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request(); // Yêu cầu quyền camera
    }
  }

  // Kiểm tra và yêu cầu quyền Lưu trữ
  static Future<void> checkAndRequestStoragePermission(BuildContext context) async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request(); // Yêu cầu quyền lưu trữ
    }
  }

  // Kiểm tra và yêu cầu quyền Thông báo
  static Future<void> checkAndRequestNotificationPermission(BuildContext context) async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request(); // Yêu cầu quyền thông báo
    }
  }
}
