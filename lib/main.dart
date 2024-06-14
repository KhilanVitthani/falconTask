import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'app/routes/app_pages.dart';
import 'app/service/databaseService.dart';

final getIt = GetIt.instance;
void main() {
  getIt.registerSingleton<DataBaseService>(DataBaseService());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
        primaryColor: Colors.yellow.withOpacity(0.7),
        appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      ),
      onInit: () {
        getIt<DataBaseService>().initDb();
      },
    ),
  );
}
