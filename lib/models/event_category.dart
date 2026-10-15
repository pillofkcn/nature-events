import 'package:flutter/material.dart';

/// Event categories with the label, icon and colour used in the UI.
enum EventCategory {
  wildfires(
    'wildfires',
    'Wildfires',
    Icons.local_fire_department,
    Colors.deepOrange,
  ),
  severeStorms(
    'severeStorms',
    'Severe Storms',
    Icons.thunderstorm,
    Colors.indigo,
  ),
  volcanoes('volcanoes', 'Volcanoes', Icons.volcano, Colors.red),
  seaLakeIce('seaLakeIce', 'Sea & Lake Ice', Icons.ac_unit, Colors.lightBlue),
  other('other', 'Other', Icons.public, Colors.blueGrey);

  const EventCategory(this.id, this.label, this.icon, this.color);

  final String id; // id used by the EONET API
  final String label;
  final IconData icon;
  final Color color;

  /// Categories that can be picked in the filter.
  static const filterable = [wildfires, severeStorms, volcanoes, seaLakeIce];

  /// Finds the category for an EONET id; unknown ids become [other].
  static EventCategory fromId(String id) {
    return EventCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => EventCategory.other,
    );
  }
}
