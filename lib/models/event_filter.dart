// event_filter.dart - nastavenia vybrane na obrazovke filtra.
// obrazovka filtra vytvori EventFilter a posle ho spat na hlavnu obrazovku;
// provider potom podla neho stiahne udalosti.

import 'event_category.dart';

/// ako zoradit zoznam: najnovsie prve, alebo najblizsie k pouzivatelovi prve.
enum SortOrder { newest, nearest }

/// nastavenia vybrane na obrazovke filtra.
class EventFilter {
  // predvolene hodnoty sa pouziju pri starte aplikacie: vsetky kategorie,
  // 50 udalosti, najnovsie prve.
  const EventFilter({
    this.category,
    this.limit = 50,
    this.sortOrder = SortOrder.newest,
  });

  final EventCategory? category; // null znamena vsetky kategorie
  final int limit; // kolko udalosti stiahnut
  final SortOrder sortOrder;
}
