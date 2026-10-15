// main.dart - vstupny bod aplikacie.
// flutter spusti ako prvu funkciu main(). tu sa vytvori stav aplikacie
// (EventsProvider) a otvori sa prva obrazovka (HomeScreen).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/events_provider.dart';
import 'screens/home_screen.dart';

void main() {
  // runApp() zobrazi nase widgety na obrazovke.
  runApp(
    // widget ChangeNotifierProvider = "krabica" s datami aplikacie (EventsProvider),
    // z ktorej mozu citat vsetky obrazovky pod nou.
    // je nad MaterialApp, takze ho vidi kazda obrazovka v aplikacii.
    ChangeNotifierProvider(
      // create: vytvori provider raz. "..init()" znamena: vytvor ho a hned
      // zavolaj init(), ktory nacita oblubene, polohu a udalosti.
      create: (context) => EventsProvider()..init(),
      child: const NatureEventsApp(),
    ),
  );
}

/// korenovy widget aplikacie: nazov, farby (tema) a prva obrazovka.
class NatureEventsApp extends StatelessWidget {
  const NatureEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // widget MaterialApp dava navigaciu (Navigator) a vzhlad Material dizajnu.
    return MaterialApp(
      title: 'Nature Events',
      // skryje cerveny napis "DEBUG" v pravom hornom rohu.
      debugShowCheckedModeBanner: false,
      // tema = farby, ktore pouzivaju vsetky tlacidla, posuvniky, chipy...
      theme: ThemeData(
        // varianta "fidelity" drzi farby blizko zadanej zelenej farby
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      // prva obrazovka, ktoru pouzivatel uvidi.
      home: const HomeScreen(),
    );
  }
}
