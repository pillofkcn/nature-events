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

/// Main screen: search, summary and the list of events.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, NatureEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
    );
  }

  void _openFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
    );
  }

  /// Opens the filter screen and waits for the filter it returns with pop.
  Future<void> _openFilter(BuildContext context) async {
    final provider = Provider.of<EventsProvider>(context, listen: false);
    final newFilter = await Navigator.push<EventFilter>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          initialFilter: provider.filter,
          hasLocation: provider.hasLocation,
        ),
      ),
    );
    if (newFilter != null) {
      provider.applyFilter(newFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nature Events'),
        actions: [
          Consumer<EventsProvider>(
            builder: (context, provider, child) => IconButton(
              tooltip: 'Favorites',
              onPressed: () => _openFavorites(context),
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
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
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
              SummaryHeader(
                count: provider.events.length,
                filter: provider.filter,
                hasLocation: provider.hasLocation,
              ),
              Expanded(child: _buildList(context, provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, EventsProvider provider) {
    final events = provider.events;

    if (provider.isLoading && events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return StateMessage(
        icon: Icons.cloud_off,
        message: provider.error!,
        buttonLabel: 'Try again',
        onPressed: provider.loadEvents,
      );
    }
    if (events.isEmpty) {
      return const StateMessage(
        icon: Icons.search_off,
        message: 'No events found.',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
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
