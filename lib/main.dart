import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/config/routes/app_routes.dart';
import 'package:parking_system/config/themes/custom_theme.dart';
import 'package:parking_system/core/firebase/firebase_options.dart';
import 'core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(const MyApp());
}

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
