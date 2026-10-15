import 'package:flutter_test/flutter_test.dart';
import 'package:nature_events/models/event_filter.dart';
import 'package:nature_events/providers/events_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Future<EventsProvider> createProvider({bool withLocation = true}) async {
  final provider = EventsProvider(
    service: FakeEonetService(),
    location: FakeLocationService(withLocation ? bratislava : null),
  );
  await provider.init();
  await Future<void>.delayed(Duration.zero); // nechaj nacitat polohu
  return provider;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('loads events, newest first', () async {
    final provider = await createProvider();

    expect(provider.events.map((e) => e.id), ['B', 'A']);
    expect(provider.isLoading, isFalse);
    expect(provider.error, isNull);
  });

  test('search keeps only matching titles', () async {
    final provider = await createProvider();

    provider.setSearch('vienna');

    expect(provider.events.map((e) => e.id), ['A']);
  });

  test('nearest sort uses the distance from the user', () async {
    final provider = await createProvider();

    await provider.applyFilter(const EventFilter(sortOrder: SortOrder.nearest));

    expect(provider.events.map((e) => e.id), ['A', 'B']);
    expect(provider.distanceKm(fireNearVienna), closeTo(56, 5));
  });

  test('without location there are no distances', () async {
    final provider = await createProvider(withLocation: false);

    expect(provider.hasLocation, isFalse);
    expect(provider.distanceKm(fireNearVienna), isNull);
  });

  test('favourites are saved and loaded again after a restart', () async {
    final provider = await createProvider();

    await provider.toggleFavorite(stormNearParis);
    expect(provider.isFavorite(stormNearParis), isTrue);

    final restarted = await createProvider();
    expect(restarted.favorites.map((e) => e.id), ['B']);

    await restarted.toggleFavorite(stormNearParis);
    expect(restarted.favorites, isEmpty);
  });
}
