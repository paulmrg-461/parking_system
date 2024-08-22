import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Login Screen'),
          FilledButton.icon(
            onPressed: () => context.go('/'),
            label: const Text('Login'),
            icon: const Icon(Icons.login_rounded),
          )
        ],
      ),
    );
  }
}
