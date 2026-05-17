import 'package:flutter/material.dart';

/// Pantalla mínima de arranque (Sprint 1, sin diseño final).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember To.App'),
      ),
      body: const Center(
        child: Text('Base local lista. Sprint 1.'),
      ),
    );
  }
}
