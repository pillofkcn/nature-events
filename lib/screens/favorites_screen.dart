import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/state_message.dart';
import 'event_detail_screen.dart';

/// Saved events. They are kept on the device, so they survive a restart.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return const StateMessage(
              icon: Icons.favorite_border,
              message:
                  'No favorites yet.\nTap the heart on an event to save it.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final event = favorites[index];
              return EventCard(
                event: event,
                distanceKm: provider.distanceKm(event),
                isFavorite: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                ),
                onFavoriteToggle: () => provider.toggleFavorite(event),
              );
            },
          );
        },
      ),
    );
  }
}
