import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(const SmartEcoApp());
}

class SmartEcoApp extends StatelessWidget {
  const SmartEcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartEco',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
