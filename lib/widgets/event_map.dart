// event_map.dart - mala mapa s miestom udalosti (na obrazovke detailu).
// pouziva balik flutter_map a mapove podklady z OpenStreetMap.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/nature_event.dart';

/// mala mapa s jednou znackou na mieste udalosti.
/// mapove podklady su z OpenStreetMap (zadarmo, bez API kluca).
class EventMap extends StatelessWidget {
  const EventMap({super.key, required this.event});

  final NatureEvent event;

  @override
  Widget build(BuildContext context) {
    // trieda LatLng = jeden bod na mape (zemepisna sirka, zemepisna dlzka).
    final position = LatLng(event.latitude, event.longitude);

    // widget FlutterMap sa sklada z vrstiev (children), ktore lezia na sebe:
    // podklad mapy, znacka, napis s autormi mapy.
    return FlutterMap(
      // zoom 2 ukaze cely svet, 12 mesto; hlbsi zoom by len stahoval viac podkladov.
      options: MapOptions(
        initialCenter: position, // mapa sa otvori nad udalostou
        initialZoom: 5,
        minZoom: 2,
        maxZoom: 12,
        // kamera ostane v jednej kopii sveta (svet sa neopakuje do stran).
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(const LatLng(-85, -180), const LatLng(85, 180)),
        ),
      ),
      children: [
        // vrstva 1: podklad mapy. obrazky (dlazdice) sa stahuju z OpenStreetMap.
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'sk.ukf.studeny.nature_events',
        ),
        // vrstva 2: znacka (spendlik) vo farbe kategorie.
        MarkerLayer(
          markers: [
            Marker(
              point: position,
              width: 48,
              height: 48,
              // spicka spendlika ukazuje presne na miesto udalosti
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.location_on,
                size: 48,
                color: event.category.color,
              ),
            ),
          ],
        ),
        // vrstva 3: napis s autormi mapy (OpenStreetMap to vyzaduje).
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
