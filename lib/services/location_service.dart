// location_service.dart - zistenie polohy pouzivatela cez GPS.
// pouziva balik geolocator. v prehliadaci (Edge) berie polohu z prehliadaca,
// na telefone z GPS telefonu.

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// raz zisti polohu pouzivatela cez GPS (v prehliadaci cez jeho polohu).
class LocationService {
  /// vrati null, ked je poloha vypnuta, nepovolena alebo nastane chyba.
  /// aplikacia funguje aj bez polohy, len neukazuje vzdialenosti.
  Future<LatLng?> getCurrentPosition() async {
    try {
      // krok 1: je v zariadeni poloha zapnuta?
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      // krok 2: smie aplikacia pouzit polohu? ked to este nie je rozhodnute,
      // opytaj sa pouzivatela (telefon/prehliadac ukaze "povolit polohu?").
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      // pouzivatel to zamietol -> ziadna poloha.
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // krok 3: zisti polohu a nechaj si len zemepisnu sirku a dlzku.
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      // akakolvek chyba (napr. vyprsal cas) -> ziadna poloha, ale ani pad.
      return null;
    }
  }
}
