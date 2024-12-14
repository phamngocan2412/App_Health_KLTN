// -- Entry point of Flutter App
// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/app.dart';
import 'package:vlu_project_1/core/services/notification_services.dart';
import 'package:vlu_project_1/data/repositories/authentication/authentication_repository.dart';
import 'package:vlu_project_1/features/home/models/database_helper.dart';
import 'package:vlu_project_1/firebase_options.dart';
import 'package:vlu_project_1/storage.dart';


Future<void> main() async {
  // Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
 
  // -- GetX Local Storage
  await StorageService().init();
 
  // -- Await Splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Env
  await dotenv.load(fileName: ".env");
 
  // -- Database Helper
  await DBHelper().initDb();

  // -- Notification
  await NotifyHelper().initializeNotification();

  // -- Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
  });

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
