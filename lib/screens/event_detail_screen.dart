import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/nature_event.dart';
import '../providers/events_provider.dart';
import '../utils/formatters.dart';
import '../widgets/category_avatar.dart';
import '../widgets/event_map.dart';
import '../widgets/info_row.dart';

/// Details of one event. The event is passed in through the constructor.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
    this.showMap = true,
  });

  final NatureEvent event;
  final bool showMap; // turned off in tests, which have no internet for tiles

  @override
  Widget build(BuildContext context) {
    final color = event.category.color;

    return Consumer<EventsProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(event);
        final distance = provider.distanceKm(event);

        return Scaffold(
          appBar: AppBar(
            title: Text(event.category.label),
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => provider.toggleFavorite(event),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(isFavorite ? 'Saved' : 'Save'),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              // Coloured header that continues the AppBar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withAlpha(170)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: CategoryAvatar(
                        category: event.category,
                        radius: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showMap)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(height: 220, child: EventMap(event: event)),
                  ),
                ),
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.category,
                        label: 'Category',
                        value: event.category.label,
                      ),
                      InfoRow(
                        icon: Icons.event,
                        label: 'Last update',
                        value: formatDate(event.date),
                      ),
                      InfoRow(
                        icon: Icons.place,
                        label: 'Coordinates',
                        value:
                            '${event.latitude.toStringAsFixed(2)}, '
                            '${event.longitude.toStringAsFixed(2)}',
                      ),
                      if (distance != null)
                        InfoRow(
                          icon: Icons.near_me,
                          label: 'Distance from you',
                          value: formatDistance(distance),
                        ),
                      if (event.magnitudeValue != null)
                        InfoRow(
                          icon: Icons.speed,
                          label: 'Magnitude',
                          value: formatMagnitude(
                            event.magnitudeValue!,
                            event.magnitudeUnit,
                          ),
                        ),
                      if (event.sourceUrl != null)
                        InfoRow(
                          icon: Icons.link,
                          label: 'Source',
                          value: event.sourceUrl!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
