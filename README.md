# Nature Events

A Flutter app that shows natural events happening around the world right now
(wildfires, severe storms, volcanoes, sea and lake ice) using the free
[NASA EONET API](https://eonet.gsfc.nasa.gov/docs/v3).

Course project for VAI (UKF Nitra).

## Features

- List of open events with search, category colours and the date of the latest update.
- Distance from you and "nearest first" sorting (GPS via `geolocator`).
- Detail screen with a small OpenStreetMap map (`flutter_map`) and event data.
- Filter screen: category, number of events and sort order.
- Favourites saved on the device (`shared_preferences`).

## Project structure

```text
lib/
├── models/      NatureEvent, EventCategory, EventFilter
├── providers/   EventsProvider (state management with Provider)
├── services/    EONET API and location
├── screens/     home, detail, filter, favourites
├── widgets/     reusable widgets (event card, map, info row...)
├── utils/       date and distance formatting
└── main.dart    entry point
```

## Run

```sh
flutter pub get
flutter run
```

## Test

```sh
flutter test
```
