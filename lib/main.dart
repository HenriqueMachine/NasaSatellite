import 'package:flutter/material.dart';
import 'package:nasa_satellite/core/app_config.dart';
import 'package:nasa_satellite/presentation/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: Routes.photosList,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
