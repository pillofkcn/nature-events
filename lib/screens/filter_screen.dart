// filter_screen.dart - formular, kde si pouzivatel vyberie, co sa ma ukazat.
// otvori sa tlacidlom filtra na hlavnej obrazovke. po stlaceni "Apply" sa
// obrazovka zavrie a posle vybrany filter spat (Navigator.pop).

import 'package:flutter/material.dart';

import '../models/event_category.dart';
import '../models/event_filter.dart';

/// formular na vyber kategorie, poctu udalosti a zoradenia.
/// vyber je lokalny stav (setState); vysledok sa vrati cez pop.
/// lokalny stav = data, ktore potrebuje len tato obrazovka, preto nie su v provideri.
class FilterScreen extends StatefulWidget {
  const FilterScreen({
    super.key,
    required this.initialFilter,
    required this.hasLocation,
  });

  final EventFilter initialFilter; // filter, ktory je prave aktivny
  final bool hasLocation; // false = nevieme, kde je pouzivatel

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

/// tzv. "stavova" cast obrazovky: drzi aktualny vyber vo formulari.
class _FilterScreenState extends State<FilterScreen> {
  EventCategory? _category; // null = vsetky kategorie
  // posuvnik (Slider) pracuje s desatinnymi cislami (double)
  double _limit = 50;
  SortOrder _sortOrder = SortOrder.newest;

  // initState sa spusti raz, este pred prvym vykreslenim obrazovky.
  @override
  void initState() {
    super.initState();
    // zacni od filtra, ktory je prave aktivny.
    _category = widget.initialFilter.category;
    _limit = widget.initialFilter.limit.toDouble();
    // bez polohy nema "Nearest" zmysel, preto "Newest".
    _sortOrder = widget.hasLocation
        ? widget.initialFilter.sortOrder
        : SortOrder.newest;
  }

  /// tlacidlo "Apply": zavri obrazovku a posli novy filter spat.
  /// hlavna obrazovka ho dostane ako vysledok "await Navigator.push".
  void _apply() {
    Navigator.pop(
      context,
      EventFilter(
        category: _category,
        limit: _limit.round(),
        sortOrder: _sortOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    return Scaffold(
      appBar: AppBar(title: const Text('Filter events')),
      // widget ListView = formular sa da posuvat, ked je obrazovka mala.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- 1) kategoria ---
          const Text('Category', style: headingStyle),
          const SizedBox(height: 8), // prazdne miesto medzi prvkami
          // widget Wrap = ako Row, ale ked uz nie je miesto, chipy pokracuju
          // na dalsom riadku.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // widget ChoiceChip = male tlacidlo, ktore sa da oznacit.
              ChoiceChip(
                showCheckmark: false,
                avatar: const Icon(Icons.public),
                label: const Text('All'),
                selected: _category == null,
                // setState zmeni hodnotu A prekresli obrazovku,
                // takze vybraty chip zmeni farbu.
                onSelected: (_) => setState(() => _category = null),
              ),
              // cyklus "for" v zozname widgetov: jeden chip pre kazdu kategoriu.
              for (final category in EventCategory.filterable)
                ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(category.icon, color: category.color),
                  label: Text(category.label),
                  selected: _category == category,
                  onSelected: (_) => setState(() => _category = category),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // --- 2) pocet udalosti ---
          Text('Number of events: ${_limit.round()}', style: headingStyle),
          // posuvnik od 10 do 100 po 10 (9 dielikov).
          Slider(
            value: _limit,
            min: 10,
            max: 100,
            divisions: 9,
            label: '${_limit.round()}',
            onChanged: (value) => setState(() => _limit = value),
          ),
          const SizedBox(height: 16),
          // --- 3) zoradenie ---
          const Text('Sort by', style: headingStyle),
          const SizedBox(height: 8),
          // widget SegmentedButton = spojene tlacidla, vybrate je vzdy len jedno.
          SegmentedButton<SortOrder>(
            segments: [
              const ButtonSegment(
                value: SortOrder.newest,
                icon: Icon(Icons.schedule),
                label: Text('Newest'),
              ),
              // moznost "Nearest" sa da vybrat len ked pozname polohu pouzivatela.
              ButtonSegment(
                value: SortOrder.nearest,
                icon: const Icon(Icons.near_me),
                label: const Text('Nearest'),
                enabled: widget.hasLocation,
              ),
            ],
            selected: {_sortOrder},
            onSelectionChanged: (selection) =>
                setState(() => _sortOrder = selection.first),
          ),
          // kratke vysvetlenie, ktore sa ukaze len ked nie je poloha.
          if (!widget.hasLocation)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Allow location access to sort by distance.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          const SizedBox(height: 32),
          // --- tlacidlo apply ---
          FilledButton.icon(
            onPressed: _apply,
            icon: const Icon(Icons.check),
            label: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
