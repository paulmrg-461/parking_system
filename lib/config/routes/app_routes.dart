import 'package:go_router/go_router.dart';
import 'package:parking_system/presentation/ui/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      name: AboutScreen.name,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
