// eonet_service.dart - komunikacia s internetom (NASA EONET API).
// provider zavola fetchEvents(); tento subor stiahne data balikom http
// a JSON odpoved zmeni na zoznam objektov NatureEvent.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_filter.dart';
import '../models/nature_event.dart';

/// stahuje otvorene prirodne udalosti z NASA EONET API.
class EonetService {
  /// slova "async" + "Future" = vysledok pride neskor (stahovanie chvilu trva).
  Future<List<NatureEvent>> fetchEvents(EventFilter filter) async {
    // zostavi adresu, napr.
    // https://eonet.gsfc.nasa.gov/api/v3/events?status=open&limit=50
    // status=open -> len udalosti, ktore este prebiehaju
    // limit -> kolko udalosti (bez neho ma odpoved cez 4 MB)
    // category -> prida sa len ked si pouzivatel vybral kategoriu vo filtri
    final uri = Uri.https('eonet.gsfc.nasa.gov', '/api/v3/events', {
      'status': 'open',
      'limit': '${filter.limit}',
      if (filter.category != null) 'category': filter.category!.id,
    });

    // slovo "await" pocka, kym server odpovie.
    final response = await http.get(uri);
    // 200 = OK. iny kod znamena chybu; provider ju zachyti
    // a ukaze "Could not load events".
    if (response.statusCode != 200) {
      throw Exception('EONET returned status ${response.statusCode}');
    }

    // jsonDecode zmeni textovu odpoved na dartove mapy a zoznamy.
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final events = data['events'] as List;
    return events
        // preskoc udalosti bez polohy (nedali by sa ukazat na mape)
        .where((json) => (json['geometry'] as List).isNotEmpty)
        // kazdy JSON objekt zmen na NatureEvent (nas datovy model)
        .map((json) => NatureEvent.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
