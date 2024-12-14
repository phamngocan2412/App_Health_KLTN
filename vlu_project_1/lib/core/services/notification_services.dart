// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:vlu_project_1/core/services/notification_page.dart';
import 'package:vlu_project_1/features/home/models/task.dart';
import 'package:get/get.dart';


class NotifyHelper {

  static final FlutterLocalNotificationsPlugin flutterNotificationService =
      FlutterLocalNotificationsPlugin();
      
  String? selectedNotificationPayload;
  
  static final BehaviorSubject<String> selectedNotificationSubject = 
      BehaviorSubject<String>();

  initializeNotification() async {
  final PermissionStatus permissionStatus = await Permission.notification.status;
    if (permissionStatus.isGranted) {
      print("Thay local");
      await Permission.notification.request();
      tz.initializeTimeZones();
      const String timeZoneName =
        'Asia/Ho_Chi_Minh';
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      await _createNotificationChannel();
      await _configureLocalTimeZone();

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings("logo");

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterNotificationService.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:  onDidReceiveNotificationResponse,
      );
    } else {
      print('Quyền thông báo chưa được cấp.');
    }
  }

  
  static void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload == null) {
        debugPrint('notification payload: $payload');
        return;
      }
      debugPrint('notification payload: $payload');
      selectedNotificationSubject.add(payload!);

      Get.to(NotificationPage(payload: payload));
    }

  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('id', 'tasks',
            channelDescription: 'Thông báo nhắc nhở',
            icon: 'logo',
            color: Color(0xFFBB2030),
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            
          );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails);

    return notificationDetails;
  }
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your channel id', 
      'your channel name', 
      description: 'your channel description', 
      importance: Importance.high, 
    );

    await flutterNotificationService
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  
  //Show Notification
  static Future<void> showNotification({
      required String title,
      required String body,
      required String? payload,
    }) async {
      var details = await _notificationDetails();

      await flutterNotificationService.show(1, title, body, details,
          payload: payload);
    }

    static Future<void> showScheduleNotification({
    required Task task,
    required int minutes,
    required int hour,
  }) async {
    var details = await _notificationDetails();
    
    final scheduledDateTime = _nextInstanceOfScheduledTime(hour, minutes, task.repeat!, task.date!); 
    final timeUntilEvent = scheduledDateTime.difference(tz.TZDateTime.now(tz.local)).inMinutes;
    final reminderTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    print("scheduledDateTime : $scheduledDateTime");
    print("timeUntilEvent : $timeUntilEvent");
    print("reminderTime : $reminderTime");

    if (timeUntilEvent > 1 && timeUntilEvent <= 6) {
      await flutterNotificationService.zonedSchedule(
        task.id!,
        "Nhắc nhở sớm: ${task.title}",
        "Sự kiện sẽ bắt đầu trong $timeUntilEvent phút",
        reminderTime,
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      await flutterNotificationService.zonedSchedule(
        task.id!.toInt(),
        "Nhắc nhở ${task.title}",
        "Thông báo đã đến giờ",
        scheduledDateTime,
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}|${task.date}|${task.startTime}",
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfScheduledTime(
      int hour, int minutes, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    DateTime formattedDate = DateFormat('dd/MM/yyyy').parse(date);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, formattedDate.year, formattedDate.month, formattedDate.day, hour, minutes);
    
    
    if (scheduledDate.isBefore(now)) {
      switch (repeat) {
        case 'Hằng ngày':
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          break;
        case 'Hằng tuần':
          scheduledDate = scheduledDate.add(const Duration(days: 7));
          break;
        case 'Hằng tháng':
          scheduledDate = tz.TZDateTime(
            tz.local,
            scheduledDate.year,
            scheduledDate.month + 1,
            scheduledDate.day,
            hour,
            minutes,
          );
          break;
      }
    }
      if (scheduledDate.year != now.year) {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, scheduledDate.month, scheduledDate.day, hour, minutes);
      }
      return scheduledDate;
    }
    

    static Future<void> _configureLocalTimeZone() async  {
      tz.initializeTimeZones();
      const String timeZoneName =
          'Asia/Ho_Chi_Minh';
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }


    static cancelNotififcationWithID(int id) async {
      await flutterNotificationService.cancel(id);
    }

    static cancelAllNotififcation() async {
      await flutterNotificationService.cancelAll();
    }
}
