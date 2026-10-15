// event_card.dart - karta jednej udalosti v zozname.
// pouziva sa na hlavnej obrazovke aj v oblubenych (ten isty widget dvakrat).

import 'package:flutter/material.dart';

import '../models/nature_event.dart';
import '../utils/formatters.dart';
import 'category_avatar.dart';

/// jedna udalost v zozname. co sa stane po kliknuti, rozhoduje rodic
/// cez callbacky [onTap] a [onFavoriteToggle].
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.distanceKm,
  });

  final NatureEvent event;
  final bool isFavorite;
  // typ VoidCallback = funkcia bez parametrov, ktoru nam posle rodic.
  // karta ju len zavola; nevie, ci sa otvori detail alebo nieco ine.
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final double? distanceKm; // null = poloha nie je znama

  @override
  Widget build(BuildContext context) {
    // spodny riadok: datum, a ked pozname polohu, aj vzdialenost.
    // join(...) ich spoji do jedneho textu s bodkou medzi nimi.
    final details = [
      formatDate(event.date),
      if (distanceKm != null) formatDistance(distanceKm!),
    ].join(' · ');

    // widget Card = biely obdlznik so zaoblenymi rohmi a tienom.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      // widget InkWell = cela karta sa da kliknut a ukaze efekt vlnky.
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          // widget Row = vedla seba: ikona | texty | srdiecko.
          child: Row(
            children: [
              CategoryAvatar(category: event.category),
              const SizedBox(width: 12), // prazdne miesto medzi prvkami
              // widget Expanded = texty zaberu celu strednu sirku; dlhy nazov sa
              // zalomi a srdiecko ostane vzdy vpravo.
              Expanded(
                // widget Column = texty pod sebou: nazov, kategoria, datum.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2, // najviac 2 riadky, potom "..."
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.category.label,
                      style: TextStyle(
                        color: event.category.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              // srdiecko: plne cervene ked je oblubena, inak prazdne.
              IconButton(
                tooltip: isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
