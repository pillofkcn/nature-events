import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Gets the user's position once with GPS (in the browser: the location API).
class LocationService {
  /// Returns null when location is turned off, not allowed or fails.
  Future<LatLng?> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }
}
