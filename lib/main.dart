import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/config/routes/app_routes.dart';
import 'package:parking_system/config/themes/custom_theme.dart';
import 'package:parking_system/core/firebase/firebase_options.dart';
import 'package:parking_system/core/service_locator.dart';
import 'package:parking_system/presentation/blocs/bloc/auth_bloc.dart';
import 'core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AuthCheckUserEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Parking System',
        theme: CustomTheme.dark,
      ),
    );
  }
}
