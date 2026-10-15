import 'package:flutter/material.dart';

import '../models/event_category.dart';

/// Round icon in the colour of the category.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category, this.radius = 24});

  final EventCategory category;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: category.color.withAlpha(40),
      child: Icon(category.icon, color: category.color, size: radius),
    );
  }
}
