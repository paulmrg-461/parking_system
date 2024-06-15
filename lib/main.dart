import 'package:flutter/material.dart';
import 'package:parking_system/config/routes/app_routes.dart';
import 'package:parking_system/config/themes/custom_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: appRouter,
        title: 'Parking System',
        theme: CustomTheme.dark);
  }
}
