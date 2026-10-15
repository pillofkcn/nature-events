// events_provider.dart - stav aplikacie (sprava stavu cez Provider).
// su tu vsetky data, ktore potrebuje viac obrazoviek: zoznam udalosti, filter,
// hladany text, oblubene a poloha pouzivatela.
// obrazovky citaju data cez Consumer a menia ich len volanim metod.

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

/// stav zdielany vsetkymi obrazovkami: udalosti, filter, hladanie, oblubene
/// a poloha pouzivatela.
/// dedi od ChangeNotifier, takze vie obrazovkam povedat "data sa zmenili,
/// prekreslite sa" zavolanim notifyListeners().
class EventsProvider extends ChangeNotifier {
  // sluzby sa daju podat zvonka. aplikacia pouziva skutocne,
  // testy podstrcia falosne (bez internetu, s pevnou polohou).
  EventsProvider({EonetService? service, LocationService? location})
    : _service = service ?? EonetService(),
      _location = location ?? LocationService();

  // nazov, pod ktorym sa oblubene ukladaju do zariadenia.
  static const _favoritesKey = 'favorites';

  final EonetService _service; // stahuje udalosti z NASA API
  final LocationService _location; // zistuje GPS polohu

  // data. nazvy so "_" na zaciatku su sukromne: ine subory ich nemozu
  // menit priamo, len cez metody nizsie.
  List<NatureEvent> _events = [];
  List<NatureEvent> _favorites = [];
  EventFilter _filter = const EventFilter();
  String _search = '';
  bool _isLoading = false;
  String? _error;
  LatLng? _userPosition;

  // gettery: ine subory mozu data CITAT, ale nie prepisat.
  EventFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _userPosition != null;
  List<NatureEvent> get favorites => List.unmodifiable(_favorites);

  /// udalosti po vyhladani a zoradeni - to, co ukazuje hlavna obrazovka.
  List<NatureEvent> get events {
    // nechaj len udalosti, ktorych nazov obsahuje hladany text.
    final query = _search.trim().toLowerCase();
    final result = _events
        .where((event) => event.title.toLowerCase().contains(query))
        .toList();

    // zoradenie: najblizsie prve (len ked pozname polohu pouzivatela),
    // inak najnovsie prve.
    if (_filter.sortOrder == SortOrder.nearest && hasLocation) {
      result.sort((a, b) => distanceKm(a)!.compareTo(distanceKm(b)!));
    } else {
      result.sort((a, b) => b.date.compareTo(a.date));
    }
    return result;
  }

  /// zavola sa raz pri starte aplikacie.
  Future<void> init() async {
    await _loadFavorites();
    // poloha sa nacitava na pozadi; vzdialenosti sa ukazu, ked bude hotova.
    unawaited(_loadLocation());
    await loadEvents();
  }

  /// stiahne udalosti z API podla aktualneho filtra.
  Future<void> loadEvents() async {
    // ukaz koliesko nacitavania a skry staru chybu.
    _isLoading = true;
    _error = null;
    notifyListeners(); // povedz obrazovkam, nech sa prekreslia

    // try/catch: ked nie je internet, aplikacia ukaze spravu
    // namiesto toho, aby spadla.
    try {
      _events = await _service.fetchEvents(_filter);
    } catch (_) {
      _error = 'Could not load events.\nCheck your internet connection.';
    }

    // nacitavanie skoncilo - prekresli obrazovky s novymi datami.
    _isLoading = false;
    notifyListeners();
  }

  /// zavola sa s vysledkom z obrazovky filtra.
  Future<void> applyFilter(EventFilter filter) async {
    _filter = filter;
    await loadEvents(); // stiahni udalosti znova s novym filtrom
  }

  /// zavola sa pri kazdom napisanom pismene vo vyhladavani.
  void setSearch(String text) {
    _search = text;
    notifyListeners();
  }

  /// vzdialenost od pouzivatela v km, alebo null, ked polohu nepozname.
  double? distanceKm(NatureEvent event) {
    final position = _userPosition;
    if (position == null) return null;

    // distanceBetween je z balika geolocator a vracia metre.
    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      event.latitude,
      event.longitude,
    );
    return meters / 1000;
  }

  /// true, ked je udalost v oblubenych.
  bool isFavorite(NatureEvent event) {
    return _favorites.any((favorite) => favorite.id == event.id);
  }

  /// prida udalost do oblubenych, alebo ju odoberie, ked tam uz je.
  Future<void> toggleFavorite(NatureEvent event) async {
    if (isFavorite(event)) {
      _favorites.removeWhere((favorite) => favorite.id == event.id);
    } else {
      _favorites.add(event);
    }
    notifyListeners(); // prekreslia sa srdiecka aj zoznam oblubenych

    // uloz oblubene, aby tam boli aj po restarte aplikacie.
    // SharedPreferences = male ulozisko v zariadeni (bonusove body).
    // vie ulozit len jednoduche hodnoty, preto sa kazda udalost
    // najprv zmeni na JSON text.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      _favorites.map((event) => jsonEncode(event.toJson())).toList(),
    );
  }

  /// nacita ulozene oblubene zo zariadenia (pri starte aplikacie).
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // zapis "?? []" = ked este nic nie je ulozene, pouzi prazdny zoznam.
    final saved = prefs.getStringList(_favoritesKey) ?? [];
    // kazdy ulozeny JSON text zmen spat na objekt NatureEvent.
    _favorites = saved
        .map((text) => NatureEvent.fromStorage(jsonDecode(text)))
        .toList();
    notifyListeners();
  }

  /// zisti GPS polohu. null znamena, ze ju nepozname.
  Future<void> _loadLocation() async {
    _userPosition = await _location.getCurrentPosition();
    notifyListeners(); // na kartach sa ukazu vzdialenosti
  }
}
