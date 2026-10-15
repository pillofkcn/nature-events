// favorites_screen.dart - zoznam udalosti, ktore si pouzivatel ulozil srdieckom.
// otvori sa tlacidlom so srdieckom v hornej liste hlavnej obrazovky.
// oblubene beru data z providera a su ulozene v zariadeni.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/state_message.dart';
import 'event_detail_screen.dart';

/// ulozene udalosti. su v zariadeni, takze vydrzia restart aplikacie.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      // widget Consumer: ked sa oblubena udalost odoberie (tu alebo v detaile),
      // provider zavola notifyListeners() a tento zoznam sa prekresli.
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          // este nic nie je ulozene -> ukaz napovedu namiesto prazdnej obrazovky.
          if (favorites.isEmpty) {
            return const StateMessage(
              icon: Icons.favorite_border,
              message:
                  'No favorites yet.\nTap the heart on an event to save it.',
            );
          }

          // tie iste karty ako na hlavnej obrazovke (znovu pouzity widget).
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final event = favorites[index];
              return EventCard(
                event: event,
                distanceKm: provider.distanceKm(event),
                isFavorite: true,
                // klik na kartu -> otvor jej detail (Navigator.push).
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                ),
                // klik na srdiecko -> odober z oblubenych.
                onFavoriteToggle: () => provider.toggleFavorite(event),
              );
            },
          );
        },
      ),
    );
  }
}
