import 'event_category.dart';

/// One natural event (wildfire, storm, volcano...) from NASA EONET.
class NatureEvent {
  const NatureEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.latitude,
    required this.longitude,
    this.magnitudeValue,
    this.magnitudeUnit,
    this.sourceUrl,
  });

  final String id;
  final String title;
  final EventCategory category;
  final DateTime date; // date of the latest observation
  final double latitude;
  final double longitude;
  final double? magnitudeValue; // e.g. wind speed of a storm
  final String? magnitudeUnit;
  final String? sourceUrl;

  /// Builds an event from the EONET API JSON.
  /// An event can have many observations ("geometry"); the last one is the newest.
  factory NatureEvent.fromJson(Map<String, dynamic> json) {
    final geometry = (json['geometry'] as List).last as Map<String, dynamic>;
    final categories = json['categories'] as List;
    final sources = json['sources'] as List;

    // A point is [longitude, latitude]. A polygon is a list of points,
    // so we go down to its first point.
    var point = geometry['coordinates'] as List;
    while (point.first is List) {
      point = point.first as List;
    }

    return NatureEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      category: EventCategory.fromId(
        categories.isEmpty ? '' : categories.first['id'] as String,
      ),
      date: DateTime.parse(geometry['date'] as String),
      latitude: (point[1] as num).toDouble(),
      longitude: (point[0] as num).toDouble(),
      magnitudeValue: (geometry['magnitudeValue'] as num?)?.toDouble(),
      magnitudeUnit: geometry['magnitudeUnit'] as String?,
      sourceUrl: sources.isEmpty ? null : sources.first['url'] as String?,
    );
  }

  /// Turns a saved favourite back into an event (see [toJson]).
  factory NatureEvent.fromStorage(Map<String, dynamic> json) {
    return NatureEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      category: EventCategory.fromId(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      magnitudeValue: (json['magnitudeValue'] as num?)?.toDouble(),
      magnitudeUnit: json['magnitudeUnit'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }

  /// Flat map used to save the event as a favourite.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.id,
      'date': date.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'magnitudeValue': magnitudeValue,
      'magnitudeUnit': magnitudeUnit,
      'sourceUrl': sourceUrl,
    };
  }
}
