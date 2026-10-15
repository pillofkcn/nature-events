import 'package:flutter/material.dart';

/// Placeholder home screen. The event list comes here later.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nature Events')),
      body: const Center(child: Text('Coming soon')),
    );
  }
}
