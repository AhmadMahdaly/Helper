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
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();

  await EasyLocalization.ensureInitialized();
  await DioFactory.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await CacheHelper.init();

  Bloc.observer = MyBlocObserver();
  userToken = await CacheHelper.getSecuredString(key: CacheKeys.userToken);

  log("User Token : $userToken");
  log("fcm Token : ${CacheHelper.getData(key: CacheKeys.deviceToken)}");

  runApp(
    EasyLocalization(
      saveLocale: true,
      useFallbackTranslations: true,
      fallbackLocale: const Locale('en', 'UK'),
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'UK'),
      ],
      path: 'assets/languages',
      child: Phoenix(
        child: const HrApp(),
      ),
    ),
  );
}

class HrApp extends StatelessWidget {
  const HrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'AppName'.tr(),
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: lightTheme,
              darkTheme: lightTheme,
              themeMode: ThemeMode.light,
              initialRoute: userToken == null
                  ? Routes.loginScreen
                  : Routes.mainlayoutScreen,
              onGenerateRoute: AppRouter().generateRoute,
              builder: EasyLoading.init(),
            );
          },
        ),
      ),
    );
  }
}
