import 'package:flutter/material.dart';

import '../models/event_filter.dart';

/// Coloured box on the home screen: number of events and the active filter.
class SummaryHeader extends StatelessWidget {
  const SummaryHeader({
    super.key,
    required this.count,
    required this.filter,
    required this.hasLocation,
  });

  final int count;
  final EventFilter filter;
  final bool hasLocation;

  @override
  Widget build(BuildContext context) {
    final category = filter.category;
    // Category colour, or the app's main colour for "All categories"
    final color = category?.color ?? Theme.of(context).colorScheme.primary;
    final sortLabel = filter.sortOrder == SortOrder.nearest && hasLocation
        ? 'Nearest first'
        : 'Newest first';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(170)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(category?.icon ?? Icons.public, color: Colors.white, size: 40),
          const SizedBox(width: 16),
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
          Icon(
            hasLocation ? Icons.location_on : Icons.location_off,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}
