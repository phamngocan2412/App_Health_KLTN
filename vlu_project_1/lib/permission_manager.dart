import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> checkAndRequestCameraPermission(BuildContext context) async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request(); 
    }
  }
  
  static Future<void> checkAndRequestStoragePermission(BuildContext context) async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request(); 
    }
  }

  static Future<void> requestAlarmPermission(BuildContext context) async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request(); 
    }
  }

  static Future<void> checkAndRequestNotificationPermission(BuildContext context) async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request(); 
    }
  }
}