// formatters.dart - pomocne funkcie, ktore zmenia hodnoty na pekny text.
// su napisane rucne, aby aplikacia nepotrebovala dalsi balik
// (napr. "intl") len kvoli tymto trom malickostiam.

// skratky mesiacov; index 0 = januar.
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// datum ako text, napr. "Oct 16, 2026"
String formatDate(DateTime date) {
  // date.month je 1-12, zoznam zacina od 0, preto "- 1".
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

/// vzdialenost ako text, napr. "2,340 km away"
String formatDistance(double km) {
  if (km < 1) return 'Less than 1 km away';

  final digits = km.round().toString(); // napr. "2340"
  final buffer = StringBuffer(); // sklada text po kusoch
  for (var i = 0; i < digits.length; i++) {
    // pred kazdu trojicu cislic daj ciarku.
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$buffer km away';
}

/// magnituda ako text, napr. "35 kts" alebo "1.5 NM^2"
String formatMagnitude(double value, String? unit) {
  // cele cisla bez desatinnych miest (35), ostatne s jednym (1.5).
  final number = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  // niektore udalosti nemaju jednotku - vtedy ukaz len cislo.
  return unit == null ? number : '$number $unit';
}
