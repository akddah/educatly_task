import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/utils/extentions.dart';
import 'feature/splash/view/splash_view.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        darkTheme: ThemeData(
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            centerTitle: true,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(extendedPadding: EdgeInsets.zero),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(fontSize: 14, color: "#8F47FE".color, fontWeight: FontWeight.w400),
            hintStyle: TextStyle(fontSize: 12, color: "#BDC1DF".color, fontWeight: FontWeight.w400),
            fillColor: '#060606'.color,
            filled: true,
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: "#EF233C".color), borderRadius: BorderRadius.circular(14)),
            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: "#F6F6FD".color), borderRadius: BorderRadius.circular(14)),
            border: OutlineInputBorder(borderSide: BorderSide(color: "#F6F6FD".color), borderRadius: BorderRadius.circular(14)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: "#8F47FE".color), borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: "#F6F6FD".color), borderRadius: BorderRadius.circular(14)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all("#8F47FE".color),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
          primaryColor: '#8F47FE'.color,
          colorScheme: const ColorScheme.dark(),
        ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: '#33333380'.color),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.sp)),
            child: child!,
          );
        },
        home: const SplashView(),
      ),
    );
  }
}







