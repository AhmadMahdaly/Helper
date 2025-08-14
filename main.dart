import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/bloc_observer.dart';
import 'package:hr_app/core/cache_helper/cache_helper.dart';
import 'package:hr_app/core/cache_helper/cache_values.dart';
import 'package:hr_app/core/constants.dart';
import 'package:hr_app/core/di.dart';
import 'package:hr_app/core/networking/dio_factory.dart';
import 'package:hr_app/core/routing/app_router.dart';
import 'package:hr_app/core/routing/routes.dart';
import 'package:hr_app/core/theming/themes.dart';

void main() async {
initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () => unfocusScope(context),
      child: MaterialApp.router(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        routerConfig: RouterGenerationConfig.goRouter,
        theme: Appthemes.lightTheme(),
      ),
    );
  }
}

void unfocusScope(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.unfocus();
  }
}

/// --> core/init/initializer.dart
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await setupGetIt();
  // Bloc.observer = MyBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

