import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const SmartEcoApp(),
    ),
  );
}

class SmartEcoApp extends StatelessWidget {
  const SmartEcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartEco',
      theme: AppTheme.lightTheme,
      // DevicePreview setup
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

