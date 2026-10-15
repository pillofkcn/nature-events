import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nature_events/main.dart';
import 'package:nature_events/models/event_category.dart';
import 'package:nature_events/providers/events_provider.dart';
import 'package:nature_events/screens/event_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Widget buildApp(EventsProvider provider, {Widget? home}) {
  return ChangeNotifierProvider.value(
    value: provider,
    child: home == null ? const NatureEventsApp() : MaterialApp(home: home),
  );
}

void main() {
  late FakeEonetService service;
  late EventsProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    service = FakeEonetService();
    provider = EventsProvider(
      service: service,
      location: FakeLocationService(bratislava),
    );
    await provider.init();
  });

  testWidgets('home lists events and the heart saves a favourite', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(provider));
    await tester.pump();

    expect(find.text('Fire near Vienna'), findsOneWidget);
    expect(find.text('Storm near Paris'), findsOneWidget);
    expect(find.text('2 active events'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pump();

    expect(provider.favorites, hasLength(1));
  });

  testWidgets('filter screen returns the chosen category with pop', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(provider));
    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Volcanoes'));
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(service.lastFilter?.category, EventCategory.volcanoes);
    expect(find.text('Nature Events'), findsOneWidget); // back on home
  });

  testWidgets('detail screen shows the event information', (tester) async {
    await tester.pumpWidget(
      buildApp(
        provider,
        home: EventDetailScreen(event: stormNearParis, showMap: false),
      ),
    );

    expect(find.text('Storm near Paris'), findsOneWidget);
    expect(find.text('45 kts'), findsOneWidget);
    expect(find.textContaining('km away'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
  });
}
