// state_message.dart - sprava v strede obrazovky (prazdny zoznam alebo chyba).
// pouziva sa na hlavnej obrazovke a v oblubenych.

import 'package:flutter/material.dart';

/// ikona a text v strede pre prazdne zoznamy a chyby, s volitelnym tlacidlom.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String message;
  // tlacidlo je volitelne: ked buttonLabel nie je zadany, tlacidlo sa neukaze.
  final String? buttonLabel;
  final VoidCallback? onPressed; // callback - co sa stane po stlaceni tlacidla

  @override
  Widget build(BuildContext context) {
    // widget Center = obsah v strede obrazovky.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          // stlpec je len taky vysoky, aky je jeho obsah
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            // zapis "if" + "..." v zozname: tlacidlo a medzera nad nim sa pridaju
            // len ked mame text tlacidla.
            if (buttonLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onPressed,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
