// summary_header.dart - farebny box na hlavnej obrazovke
// (napr. "50 active events", aktivny filter a ikona polohy).

import 'package:flutter/material.dart';

import '../models/event_filter.dart';

/// farebny box na hlavnej obrazovke: pocet udalosti a aktivny filter.
class SummaryHeader extends StatelessWidget {
  const SummaryHeader({
    super.key,
    required this.count,
    required this.filter,
    required this.hasLocation,
  });

  final int count; // kolko udalosti je v zozname
  final EventFilter filter; // aktivny filter
  final bool hasLocation; // pozname polohu pouzivatela?

  @override
  Widget build(BuildContext context) {
    final category = filter.category;
    // farba kategorie, alebo hlavna farba aplikacie pre "All categories"
    final color = category?.color ?? Theme.of(context).colorScheme.primary;
    // text o zoradeni; "Nearest" ma zmysel len ked pozname polohu.
    final sortLabel = filter.sortOrder == SortOrder.nearest && hasLocation
        ? 'Nearest first'
        : 'Newest first';

    // widget Container = box, ktoremu sa da nastavit farba, okraje a zaoblenie.
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // prechod farieb z laveho horneho rohu do praveho dolneho.
        gradient: LinearGradient(
          colors: [color, color.withAlpha(170)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      // widget Row = vedla seba: ikona kategorie | texty | ikona polohy.
      child: Row(
        children: [
          Icon(category?.icon ?? Icons.public, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          // widget Expanded = texty zaberu stred, ikona polohy ostane vpravo.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count active events',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category?.label ?? 'All categories'} · $sortLabel',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // ikona ukazuje, ci pozname polohu (zapnuta / vypnuta).
          Icon(
            hasLocation ? Icons.location_on : Icons.location_off,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}
