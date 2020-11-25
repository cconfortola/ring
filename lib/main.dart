import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:ring/screens/home_screen.dart';

void main() => runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('de')],
        fallbackLocale: Locale('en'),
        path: 'i18n/',
        assetLoader: YamlAssetLoader(),
        child: RingApp(),
      ),
    );

class RingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Ring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
