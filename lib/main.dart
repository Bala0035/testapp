import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'database/cart_cache_item.dart';
import 'database/filter.dart';
import 'database/filter_active.dart';
import 'database/filter_value.dart';
import 'database/product.dart';
import 'database/user.dart';
import 'locator.dart';
import 'screens/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ru')
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      saveLocale: true,
      child: WooShopApp(),
    )
  );
}

class WooShopApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WooShopAppState();
}

class _WooShopAppState extends State<WooShopApp> {
  late Future dependencyFuture;

  @override
  void initState() {
    super.initState();
    initHive();
    dependencyFuture = setupDependencies();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: tr('app_name'),
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    debugShowCheckedModeBanner: false,
    home: FutureBuilder(
      future: dependencyFuture,
      builder: (context, snapshot) => SplashScreen(),
    ),
  );

  void initHive() async {
    Hive
      ..initFlutter()
      ..registerAdapter(CartCacheItemAdapter())
      ..registerAdapter(FilterValueAdapter())
      ..registerAdapter(ActiveFilterAdapter())
      ..registerAdapter(FilterAdapter())
      ..registerAdapter(ViewedProductAdapter())
      ..registerAdapter(UserAdapter());
  }
}
