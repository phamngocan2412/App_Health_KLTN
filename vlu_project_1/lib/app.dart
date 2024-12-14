// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/core/bindings/general_bindings.dart';
import 'package:vlu_project_1/core/utils/assets/theme.dart';
import 'package:vlu_project_1/route.dart';
import 'package:vlu_project_1/shared/size_config.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        SizeConfig().init(context);
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Medicine And Notification',
          theme: theme(),
          initialRoute: TRoutes.navigationMenu,
          initialBinding: GeneralBindings(),
          getPages: TAppRoute.pages,
          unknownRoute: GetPage(
            name: '/page-not-found',
            page: () => const Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            ),
          ),
        );
      },
    );
  }
}