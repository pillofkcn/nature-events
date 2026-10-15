// event_detail_screen.dart - detail jednej udalosti.
// otvori sa po kliknuti na kartu udalosti (na hlavnej obrazovke alebo v oblubenych).
// ukazuje farebnu hlavicku, malu mapu a vsetky informacie o udalosti.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/nature_event.dart';
import '../providers/events_provider.dart';
import '../utils/formatters.dart';
import '../widgets/category_avatar.dart';
import '../widgets/event_map.dart';
import '../widgets/info_row.dart';

/// detail jednej udalosti. udalost pride cez konstruktor.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
    this.showMap = true,
  });

  // udalost na zobrazenie (posle ju predosla obrazovka)
  final NatureEvent event;
  // v testoch je mapa vypnuta, lebo testy nemaju internet na podklady mapy
  final bool showMap;

  @override
  Widget build(BuildContext context) {
    // kazda kategoria ma svoju farbu (poziar = oranzova, burka = modra...).
    final color = event.category.color;

    // widget Consumer: obrazovka sa prekresli, ked sa provider zmeni, napr.
    // po stlaceni "Save" sa zmeni srdiecko aj text.
    return Consumer<EventsProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(event);
        final distance = provider.distanceKm(event);

        return Scaffold(
          // horna lista vo farbe kategorie. sipku spat prida flutter sam
          // a zavrie tuto obrazovku (Navigator.pop).
          appBar: AppBar(
            title: Text(event.category.label),
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          // velke okruhle tlacidlo dole: ulozit / odobrat z oblubenych.
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => provider.toggleFavorite(event),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(isFavorite ? 'Saved' : 'Save'),
          ),
          // widget ListView = obsah sa da posuvat na malej obrazovke.
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88), // miesto pre tlacidlo
            children: [
              // farebna hlavicka, ktora nadvazuje na AppBar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                // prechod farieb = farba je zhora nadol postupne svetlejsia.
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withAlpha(170)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                // widget Row = widgety vedla seba: ikona + nazov.
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: CategoryAvatar(
                        category: event.category,
                        radius: 28,
                      ),
                    ),
                    const SizedBox(width: 16), // prazdne miesto medzi prvkami
                    // widget Expanded = nazov zaberie zvysok sirky a ked je dlhy,
                    // zalomi sa na viac riadkov.
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // podmienka "if" v zozname widgetov: mapa sa prida len vtedy,
              // ked je showMap true (v testoch je false).
              if (showMap)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  // widget ClipRRect oreze mapu do tvaru so zaoblenymi rohmi.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(height: 220, child: EventMap(event: event)),
                  ),
                ),
              // karta so vsetkymi informaciami, jeden InfoRow na riadok.
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.category,
                        label: 'Category',
                        value: event.category.label,
                      ),
                      InfoRow(
                        icon: Icons.event,
                        label: 'Last update',
                        value: formatDate(event.date),
                      ),
                      InfoRow(
                        icon: Icons.place,
                        label: 'Coordinates',
                        value:
                            '${event.latitude.toStringAsFixed(2)}, '
                            '${event.longitude.toStringAsFixed(2)}',
                      ),
                      // dalsie riadky sa ukazu len ked hodnota existuje
                      // (bez GPS nie je vzdialenost, sopky nemaju magnitudu).
                      if (distance != null)
                        InfoRow(
                          icon: Icons.near_me,
                          label: 'Distance from you',
                          value: formatDistance(distance),
                        ),
                      if (event.magnitudeValue != null)
                        InfoRow(
                          icon: Icons.speed,
                          label: 'Magnitude',
                          value: formatMagnitude(
                            event.magnitudeValue!,
                            event.magnitudeUnit,
                          ),
                        ),
                      if (event.sourceUrl != null)
                        InfoRow(
                          icon: Icons.link,
                          label: 'Source',
                          value: event.sourceUrl!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
