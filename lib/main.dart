import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/events_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    // Registered above MaterialApp, so every screen can use EventsProvider.
    ChangeNotifierProvider(
      create: (context) => EventsProvider()..init(),
      child: const NatureEventsApp(),
    ),
  );
}

class NatureEventsApp extends StatelessWidget {
  const NatureEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nature Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // "fidelity" keeps the colours close to the green seed colour
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
