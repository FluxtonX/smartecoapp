import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smarteco/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'core/providers/locale_provider.dart';
import 'controller/auth_controller.dart';
import 'controller/user_controller.dart';
import 'controller/bin_controller.dart';
import 'controller/pickup_controller.dart';
import 'core/theme/app_theme.dart';
import 'views/splash/splash_screen.dart';

class FallbackLocalizationDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return await GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackLocalizationDelegate old) => false;
}

class FallbackCupertinoLocalizationDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return await GlobalCupertinoLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => BinController()),
        ChangeNotifierProvider(create: (_) => PickupController()),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const SmartEcoApp(),
      ),
    ),
  );
}

class SmartEcoApp extends StatelessWidget {
  const SmartEcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'SmartEco',
      theme: AppTheme.lightTheme,
      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      supportedLocales: LocaleProvider.supportedLocales,
      locale: localeProvider.locale ?? DevicePreview.locale(context),
      // DevicePreview setup
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

