// home_screen.dart - hlavna obrazovka (prva, ktoru pouzivatel uvidi).
// ukazuje vyhladavanie, farebny suhrn a zoznam udalosti.
// odtialto sa otvara detail, filter a oblubene.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_filter.dart';
import '../models/nature_event.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/state_message.dart';
import '../widgets/summary_header.dart';
import 'event_detail_screen.dart';
import 'favorites_screen.dart';
import 'filter_screen.dart';

/// hlavna obrazovka: vyhladavanie, suhrn a zoznam udalosti.
/// je to StatelessWidget, lebo vsetky data berie z providera.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// otvori detail jednej udalosti.
  void _openDetail(BuildContext context, NatureEvent event) {
    // metoda Navigator.push polozi novu obrazovku navrch tejto.
    // udalost sa novej obrazovke posle cez jej konstruktor.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
    );
  }

  /// otvori obrazovku oblubenych.
  void _openFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
    );
  }

  /// otvori obrazovku filtra a pocka na filter, ktory vrati cez pop.
  Future<void> _openFilter(BuildContext context) async {
    // listen: false - tu len citame data a volame metodu,
    // tento kod sa nemusi prekreslovat, ked sa data zmenia.
    final provider = Provider.of<EventsProvider>(context, listen: false);
    // slovo "await" pocka, kym sa obrazovka filtra zavrie. co filter posle do
    // Navigator.pop(context, ...), to sa sem vrati ako newFilter.
    final newFilter = await Navigator.push<EventFilter>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          initialFilter: provider.filter,
          hasLocation: provider.hasLocation,
        ),
      ),
    );
    // newFilter je null, ked sa pouzivatel vratil spat bez tlacidla Apply.
    if (newFilter != null) {
      provider.applyFilter(newFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget Scaffold = zakladne rozlozenie stranky: horna lista (AppBar) + obsah (body).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nature Events'),
        // actions = tlacidla na pravej strane hornej listy
        actions: [
          // widget Consumer prekresli len toto tlacidlo, ked sa provider zmeni,
          // takze pocet oblubenych na srdiecku je vzdy aktualny.
          Consumer<EventsProvider>(
            builder: (context, provider, child) => IconButton(
              tooltip: 'Favorites',
              onPressed: () => _openFavorites(context),
              // widget Badge = mala bublina s cislom nad ikonou.
              icon: Badge(
                isLabelVisible: provider.favorites.isNotEmpty,
                label: Text('${provider.favorites.length}'),
                child: const Icon(Icons.favorite_border),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Filter',
            onPressed: () => _openFilter(context),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      // widget Consumer: vsetko vo vnutri sa prekresli, ked provider zavola
      // notifyListeners() (nove udalosti, hladanie, poloha...).
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          // widget Column = widgety pod sebou (vyhladavanie, suhrn, zoznam).
          return Column(
            children: [
              // vyhladavacie pole. kazde pismeno zavola provider.setSearch.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  onChanged: provider.setSearch,
                  decoration: InputDecoration(
                    hintText: 'Search events',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // farebny box: "50 active events" + aktivny filter.
              SummaryHeader(
                count: provider.events.length,
                filter: provider.filter,
                hasLocation: provider.hasLocation,
              ),
              // widget Expanded = zoznam zaberie celu zvysnu vysku obrazovky
              // (bez neho by ListView vo vnutri Column nefungoval).
              Expanded(child: _buildList(context, provider)),
            ],
          );
        },
      ),
    );
  }

  /// cast so zoznamom: koliesko, chyba, prazdna sprava alebo zoznam.
  Widget _buildList(BuildContext context, EventsProvider provider) {
    final events = provider.events;

    // 1) este sa stahuje a nie je co ukazat -> koliesko nacitavania.
    if (provider.isLoading && events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    // 2) stahovanie zlyhalo -> sprava s tlacidlom "Try again".
    //    onPressed je callback: tlacidlo zavola provider.loadEvents.
    if (provider.error != null) {
      return StateMessage(
        icon: Icons.cloud_off,
        message: provider.error!,
        buttonLabel: 'Try again',
        onPressed: provider.loadEvents,
      );
    }
    // 3) nic nezodpoveda hladaniu -> sprava, ze nic nenaslo.
    if (events.isEmpty) {
      return const StateMessage(
        icon: Icons.search_off,
        message: 'No events found.',
      );
    }

    // 4) zoznam. RefreshIndicator = potiahni zoznam nadol a stiahne sa znova.
    return RefreshIndicator(
      onRefresh: provider.loadEvents,
      // widget ListView.builder vytvara len karty, ktore su prave vidno,
      // takze aj dlhy zoznam zostane rychly.
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          // karta dostane data a dva callbacky: co sa ma stat po kliknuti
          // na kartu a co po kliknuti na srdiecko.
          return EventCard(
            event: event,
            distanceKm: provider.distanceKm(event),
            isFavorite: provider.isFavorite(event),
            onTap: () => _openDetail(context, event),
            onFavoriteToggle: () => provider.toggleFavorite(event),
          );
        },
      ),
    );
  }
}
