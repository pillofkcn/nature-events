import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/nature_event.dart';

/// Small map with one marker at the event's position.
/// Map tiles come from OpenStreetMap (free, no API key).
class EventMap extends StatelessWidget {
  const EventMap({super.key, required this.event});

  final NatureEvent event;

  @override
  Widget build(BuildContext context) {
    final position = LatLng(event.latitude, event.longitude);

    return FlutterMap(
      options: MapOptions(initialCenter: position, initialZoom: 5),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'sk.ukf.studeny.nature_events',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: position,
              width: 48,
              height: 48,
              alignment: Alignment.topCenter, // pin tip points at the event
              child: Icon(
                Icons.location_on,
                size: 48,
                color: event.category.color,
              ),
            ),
          ],
        ),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
