import 'package:flutter/material.dart';

import '../models/nature_event.dart';
import '../utils/formatters.dart';
import 'category_avatar.dart';

/// One event in a list. What happens on tap is decided by the parent
/// through the [onTap] and [onFavoriteToggle] callbacks.
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
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final details = [
      formatDate(event.date),
      if (distanceKm != null) formatDistance(distanceKm!),
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              CategoryAvatar(category: event.category),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
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
