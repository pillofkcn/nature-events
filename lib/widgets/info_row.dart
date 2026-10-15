// info_row.dart - jeden riadok s informaciou na obrazovke detailu
// (napr. ikona kalendara, "Last update" a pod tym datum).

import 'package:flutter/material.dart';

/// ikona, maly popis a pod nim hodnota (pouziva sa na obrazovke detailu).
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label; // maly sivy popis, napr. "Coordinates"
  final String value; // hodnota, napr. "12.90, -101.60"

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // widget Row = ikona vlavo, texty vpravo od nej.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // farba ikony je hlavna farba aplikacie (zelena z temy).
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          // widget Expanded = dlha hodnota (napr. odkaz) sa zalomi na viac riadkov.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
