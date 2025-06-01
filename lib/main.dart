import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/database_service.dart';
import 'app/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Get.putAsync(() => DatabaseService().init());
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder:
          (controller) => GetMaterialApp(
            title: 'Notes App',
            theme: controller.lightTheme,
            darkTheme: controller.darkTheme,
            themeMode: controller.themeMode.value,
            initialRoute: AppRoutes.HOME,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
          ),
    );
  }
}
