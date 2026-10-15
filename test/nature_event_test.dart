import 'package:flutter_test/flutter_test.dart';
import 'package:nature_events/models/event_category.dart';
import 'package:nature_events/models/nature_event.dart';

void main() {
  test('fromJson reads the newest observation of an EONET event', () {
    final event = NatureEvent.fromJson({
      'id': 'EONET_1',
      'title': 'Hurricane Trudy',
      'categories': [
        {'id': 'severeStorms', 'title': 'Severe Storms'},
      ],
      'sources': [
        {'id': 'JTWC', 'url': 'https://example.com/storm'},
      ],
      'geometry': [
        {
          'magnitudeValue': 35,
          'magnitudeUnit': 'kts',
          'date': '2026-10-13T18:00:00Z',
          'type': 'Point',
          'coordinates': [-95.9, 10.3],
        },
        {
          'magnitudeValue': 65,
          'magnitudeUnit': 'kts',
          'date': '2026-10-15T00:00:00Z',
          'type': 'Point',
          'coordinates': [-100.5, 12.1],
        },
      ],
    });

    expect(event.category, EventCategory.severeStorms);
    expect(event.date, DateTime.utc(2026, 10, 15));
    expect(event.latitude, 12.1); // coordinates are [longitude, latitude]
    expect(event.longitude, -100.5);
    expect(event.magnitudeValue, 65);
    expect(event.sourceUrl, 'https://example.com/storm');
  });

  test('fromJson handles a volcano without magnitude', () {
    final event = NatureEvent.fromJson({
      'id': 'EONET_2',
      'title': 'Etna Volcano, Italy',
      'categories': [
        {'id': 'volcanoes', 'title': 'Volcanoes'},
      ],
      'sources': [],
      'geometry': [
        {
          'magnitudeValue': null,
          'magnitudeUnit': null,
          'date': '2026-06-15T00:00:00Z',
          'type': 'Point',
          'coordinates': [14.99, 37.75],
        },
      ],
    });

    expect(event.category, EventCategory.volcanoes);
    expect(event.magnitudeValue, isNull);
    expect(event.sourceUrl, isNull);
  });

  test('toJson and fromStorage give back the same event', () {
    final event = NatureEvent(
      id: 'X',
      title: 'Ice',
      category: EventCategory.seaLakeIce,
      date: DateTime.utc(2026, 1, 2),
      latitude: -70,
      longitude: 10,
      magnitudeValue: 12.5,
      magnitudeUnit: 'NM^2',
    );

    final copy = NatureEvent.fromStorage(event.toJson());

    expect(copy.id, event.id);
    expect(copy.category, event.category);
    expect(copy.date, event.date);
    expect(copy.magnitudeValue, event.magnitudeValue);
  });
}
