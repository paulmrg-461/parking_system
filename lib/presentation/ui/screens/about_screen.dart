import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  static const String name = 'about_screen';
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Screen'),
      ),
      body: Column(
        children: [
          const Text('About Screen'),
          TextButton.icon(
            onPressed: () => context.go('/'),
            label: const Text('Go home'),
            icon: const Icon(Icons.home),
          )
        ],
      ),
    );
  }
}
