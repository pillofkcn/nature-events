import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_filter.dart';
import '../models/nature_event.dart';
import '../services/eonet_service.dart';
import '../services/location_service.dart';

/// App state shared by all screens: events, filter, search, favourites
/// and the user's position.
class EventsProvider extends ChangeNotifier {
  EventsProvider({EonetService? service, LocationService? location})
    : _service = service ?? EonetService(),
      _location = location ?? LocationService();

  static const _favoritesKey = 'favorites';

  final EonetService _service;
  final LocationService _location;

  List<NatureEvent> _events = [];
  List<NatureEvent> _favorites = [];
  EventFilter _filter = const EventFilter();
  String _search = '';
  bool _isLoading = false;
  String? _error;
  LatLng? _userPosition;

  EventFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _userPosition != null;
  List<NatureEvent> get favorites => List.unmodifiable(_favorites);

  /// Events after the search and sorting – what the home screen shows.
  List<NatureEvent> get events {
    final query = _search.trim().toLowerCase();
    final result = _events
        .where((event) => event.title.toLowerCase().contains(query))
        .toList();

    if (_filter.sortOrder == SortOrder.nearest && hasLocation) {
      result.sort((a, b) => distanceKm(a)!.compareTo(distanceKm(b)!));
    } else {
      result.sort((a, b) => b.date.compareTo(a.date));
    }
    return result;
  }

  /// Called once when the app starts.
  Future<void> init() async {
    await _loadFavorites();
    // The position is loaded in the background; distances appear when ready.
    unawaited(_loadLocation());
    await loadEvents();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.fetchEvents(_filter);
    } catch (_) {
      _error = 'Could not load events.\nCheck your internet connection.';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Called with the result of the filter screen.
  Future<void> applyFilter(EventFilter filter) async {
    _filter = filter;
    await loadEvents();
  }

  void setSearch(String text) {
    _search = text;
    notifyListeners();
  }

  /// Distance from the user in km, or null when the position is unknown.
  double? distanceKm(NatureEvent event) {
    final position = _userPosition;
    if (position == null) return null;

    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      event.latitude,
      event.longitude,
    );
    return meters / 1000;
  }

  bool isFavorite(NatureEvent event) {
    return _favorites.any((favorite) => favorite.id == event.id);
  }

  Future<void> toggleFavorite(NatureEvent event) async {
    if (isFavorite(event)) {
      _favorites.removeWhere((favorite) => favorite.id == event.id);
    } else {
      _favorites.add(event);
    }
    notifyListeners();

    // Save the favourites so they are still there after a restart.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      _favorites.map((event) => jsonEncode(event.toJson())).toList(),
    );
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = saved
        .map((text) => NatureEvent.fromStorage(jsonDecode(text)))
        .toList();
    notifyListeners();
  }

  Future<void> _loadLocation() async {
    _userPosition = await _location.getCurrentPosition();
    notifyListeners();
  }
}
