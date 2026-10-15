import 'package:flutter_test/flutter_test.dart';

import 'package:nature_events/main.dart';

void main() {
  testWidgets('App starts on the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NatureEventsApp());

    expect(find.text('Nature Events'), findsOneWidget);
  });
}
