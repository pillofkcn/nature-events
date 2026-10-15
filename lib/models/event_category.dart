// event_category.dart - druhy udalosti (poziare, burky, sopky...).
// kazda kategoria ma nazov, ikonu a farbu na jednom mieste, takze cela
// aplikacia ukazuje pre tu istu kategoriu tu istu farbu a ikonu.

import 'package:flutter/material.dart';

/// kategorie udalosti s nazvom, ikonou a farbou pre UI.
/// je to "rozsireny enum": kazda hodnota nesie v zatvorke dalsie data
/// (id, nazov, ikona, farba).
enum EventCategory {
  wildfires(
    'wildfires',
    'Wildfires',
    Icons.local_fire_department,
    Colors.deepOrange,
  ),
  severeStorms(
    'severeStorms',
    'Severe Storms',
    Icons.thunderstorm,
    Colors.indigo,
  ),
  volcanoes('volcanoes', 'Volcanoes', Icons.volcano, Colors.red),
  seaLakeIce('seaLakeIce', 'Sea & Lake Ice', Icons.ac_unit, Colors.lightBlue),
  // hodnota "other" sa pouzije pre kazdu kategoriu, ktoru aplikacia nepozna.
  other('other', 'Other', Icons.public, Colors.blueGrey);

  // konstruktor enumu: ulozi styri hodnoty zo zatvoriek vyssie.
  const EventCategory(this.id, this.label, this.icon, this.color);

  final String id; // id, ktore pouziva EONET API
  final String label; // text, ktory vidi pouzivatel
  final IconData icon;
  final Color color;

  /// kategorie, ktore sa daju vybrat vo filtri.
  static const filterable = [wildfires, severeStorms, volcanoes, seaLakeIce];

  /// najde kategoriu podla id z EONET; nezname id bude [other].
  static EventCategory fromId(String id) {
    // firstWhere prejde vsetky hodnoty a vrati prvu, ktora sedi.
    return EventCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => EventCategory.other,
    );
  }
}
