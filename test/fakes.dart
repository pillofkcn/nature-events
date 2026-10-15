import 'package:latlong2/latlong.dart';
import 'package:nature_events/models/event_category.dart';
import 'package:nature_events/models/event_filter.dart';
import 'package:nature_events/models/nature_event.dart';
import 'package:nature_events/services/eonet_service.dart';
import 'package:nature_events/services/location_service.dart';

/// Test events: Bratislava is about 50 km from Vienna and 1,300 km from Paris.
final fireNearVienna = NatureEvent(
  id: 'A',
  title: 'Fire near Vienna',
  category: EventCategory.wildfires,
  date: DateTime(2026, 10, 10),
  latitude: 48.21,
  longitude: 16.37,
);

final stormNearParis = NatureEvent(
  id: 'B',
  title: 'Storm near Paris',
  category: EventCategory.severeStorms,
  date: DateTime(2026, 10, 14),
  latitude: 48.86,
  longitude: 2.35,
  magnitudeValue: 45,
  magnitudeUnit: 'kts',
);

class FakeEonetService extends EonetService {
  EventFilter? lastFilter;

  @override
  Future<List<NatureEvent>> fetchEvents(EventFilter filter) async {
    lastFilter = filter;
    return [fireNearVienna, stormNearParis];
  }
}

class FakeLocationService extends LocationService {
  FakeLocationService(this.position);

  final LatLng? position;

  @override
  Future<LatLng?> getCurrentPosition() async => position;
}

const bratislava = LatLng(48.15, 17.11);
