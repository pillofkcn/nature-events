// nature_event.dart - datovy model jednej udalosti (nasa vlastna trieda).
// aplikacia pracuje s objektmi NatureEvent namiesto suroveho JSON-u z API.
// tento subor zmeni JSON na udalost a naopak (pri ukladani oblubenych).

import 'event_category.dart';

/// jedna prirodna udalost (poziar, burka, sopka...) z NASA EONET.
class NatureEvent {
  // zapis "const" konstruktor + "final" polia = udalost sa po vytvoreni
  // uz nikdy nezmeni.
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
  final DateTime date; // datum posledneho pozorovania
  final double latitude;
  final double longitude;
  // polia s "?" mozu byt null - nie kazda udalost ich ma
  // (napr. sopky nemaju magnitudu).
  final double? magnitudeValue; // napr. rychlost vetra pri burke
  final String? magnitudeUnit;
  final String? sourceUrl;

  /// vytvori udalost z JSON-u, ktory vrati EONET API.
  /// udalost moze mat viac pozorovani ("geometry"); posledne je najnovsie.
  /// "factory" = konstruktor, ktory najprv nieco spravi (precita JSON)
  /// a potom vrati novy objekt.
  factory NatureEvent.fromJson(Map<String, dynamic> json) {
    // zapis "as List" / "as String" povie dartu, aky typ ma hodnota z JSON-u
    // (pretypovanie, ako v quiz appke z kurzu).
    final geometry = (json['geometry'] as List).last as Map<String, dynamic>;
    final categories = json['categories'] as List;
    final sources = json['sources'] as List;

    // bod je [longitude, latitude]. polygon je zoznam bodov,
    // preto ideme dovnutra az k jeho prvemu bodu.
    var point = geometry['coordinates'] as List;
    while (point.first is List) {
      point = point.first as List;
    }

    return NatureEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      // udalost bez kategorie dostane "other".
      category: EventCategory.fromId(
        categories.isEmpty ? '' : categories.first['id'] as String,
      ),
      date: DateTime.parse(geometry['date'] as String),
      latitude: (point[1] as num).toDouble(),
      longitude: (point[0] as num).toDouble(),
      // zapis "as num?" + "?." = ked je hodnota null, vysledok je tiez null.
      magnitudeValue: (geometry['magnitudeValue'] as num?)?.toDouble(),
      magnitudeUnit: geometry['magnitudeUnit'] as String?,
      sourceUrl: sources.isEmpty ? null : sources.first['url'] as String?,
    );
  }

  /// zmeni ulozenu oblubenu udalost spat na objekt (pozri [toJson]).
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

  /// jednoducha mapa na ulozenie udalosti medzi oblubene.
  /// je jednoduchsia ako JSON z API: len hodnoty, ktore potrebujeme.
  /// provider ju zmeni na text (jsonEncode) a ulozi.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.id,
      'date': date.toIso8601String(), // datum ako text, napr. 2026-10-15T00:00
      'latitude': latitude,
      'longitude': longitude,
      'magnitudeValue': magnitudeValue,
      'magnitudeUnit': magnitudeUnit,
      'sourceUrl': sourceUrl,
    };
  }
}
