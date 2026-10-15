import 'event_category.dart';

enum SortOrder { newest, nearest }

/// Settings chosen on the filter screen.
class EventFilter {
  const EventFilter({
    this.category,
    this.limit = 50,
    this.sortOrder = SortOrder.newest,
  });

  final EventCategory? category; // null means all categories
  final int limit; // how many events to download
  final SortOrder sortOrder;
}
