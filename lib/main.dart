import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_orange2/constants/theme.dart';
import 'package:test_orange2/screens/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Test Orange',
          theme: lightTheme, 
          darkTheme: darkTheme, 
          themeMode: ThemeMode.system,
          home: const Splashscreen(),
        );
      },
    );
  }
}
