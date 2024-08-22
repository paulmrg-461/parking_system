import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parking_system/presentation/ui/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AboutScreen.name),
        child: const Icon(Icons.info_outline_rounded),
      ),
    );
  }
}
