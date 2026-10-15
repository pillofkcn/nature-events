import 'package:flutter/material.dart';

import '../models/event_category.dart';
import '../models/event_filter.dart';

/// Form for choosing the category, number of events and sort order.
/// The choices are local state (setState); the result goes back with pop.
class FilterScreen extends StatefulWidget {
  const FilterScreen({
    super.key,
    required this.initialFilter,
    required this.hasLocation,
  });

  final EventFilter initialFilter;
  final bool hasLocation;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  EventCategory? _category;
  double _limit = 50;
  SortOrder _sortOrder = SortOrder.newest;

  @override
  void initState() {
    super.initState();
    // Start from the filter that is active now.
    _category = widget.initialFilter.category;
    _limit = widget.initialFilter.limit.toDouble();
    _sortOrder = widget.hasLocation
        ? widget.initialFilter.sortOrder
        : SortOrder.newest;
  }

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Category', style: headingStyle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                showCheckmark: false,
                avatar: const Icon(Icons.public),
                label: const Text('All'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
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
          Text('Number of events: ${_limit.round()}', style: headingStyle),
          Slider(
            value: _limit,
            min: 10,
            max: 100,
            divisions: 9,
            label: '${_limit.round()}',
            onChanged: (value) => setState(() => _limit = value),
          ),
          const SizedBox(height: 16),
          const Text('Sort by', style: headingStyle),
          const SizedBox(height: 8),
          SegmentedButton<SortOrder>(
            segments: [
              const ButtonSegment(
                value: SortOrder.newest,
                icon: Icon(Icons.schedule),
                label: Text('Newest'),
              ),
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
          if (!widget.hasLocation)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Allow location access to sort by distance.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          const SizedBox(height: 32),
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
