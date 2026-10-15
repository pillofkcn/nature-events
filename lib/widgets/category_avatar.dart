// category_avatar.dart - okruhla ikona kategorie.
// pouziva sa na kartach udalosti a v hlavicke detailu.

import 'package:flutter/material.dart';

import '../models/event_category.dart';

/// okruhla ikona vo farbe kategorie.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category, this.radius = 24});

  final EventCategory category;
  final double radius; // velkost kruhu (polomer)

  @override
  Widget build(BuildContext context) {
    // widget CircleAvatar = kruh; pozadie je svetla verzia farby kategorie
    // (withAlpha = priehladnost), ikona je v plnej farbe.
    return CircleAvatar(
      radius: radius,
      backgroundColor: category.color.withAlpha(40),
      child: Icon(category.icon, color: category.color, size: radius),
    );
  }
}
