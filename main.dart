import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:.../core/routing/app_router.dart';
import 'package:.../core/routing/routes.dart';
import 'package:.../core/theming/themes.dart';

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

