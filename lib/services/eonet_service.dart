import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_filter.dart';
import '../models/nature_event.dart';

/// Downloads open natural events from the NASA EONET API.
class EonetService {
  Future<List<NatureEvent>> fetchEvents(EventFilter filter) async {
    final uri = Uri.https('eonet.gsfc.nasa.gov', '/api/v3/events', {
      'status': 'open',
      'limit': '${filter.limit}',
      if (filter.category != null) 'category': filter.category!.id,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('EONET returned status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final events = data['events'] as List;
    return events
        .where((json) => (json['geometry'] as List).isNotEmpty)
        .map((json) => NatureEvent.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
