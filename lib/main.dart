import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const NatureEventsApp());
}

class NatureEventsApp extends StatelessWidget {
  const NatureEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nature Events',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}
