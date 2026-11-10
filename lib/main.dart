import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/core/app_dependencies.dart';
import 'package:jamal_flutter_app/core/theme/app_theme.dart';
import 'package:jamal_flutter_app/core/theme/theme_controller.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/routes/app_routes_file.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorageService.init();
  await AppFiles.init();
  await AppDependencies.init();
  // TODO(firebase): await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        AuthService.to.isLoggedIn ? AppRoutes.main : AppRoutes.signIn;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        title: AppConstString.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeController.to.mode.value,
        initialRoute: initialRoute,
        getPages: AppRoutesFile.pages,
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
