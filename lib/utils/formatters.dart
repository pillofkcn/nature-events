const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Oct 16, 2026"
String formatDate(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

/// "2,340 km away"
String formatDistance(double km) {
  if (km < 1) return 'Less than 1 km away';

  final digits = km.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    // Put a comma before every group of three digits.
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$buffer km away';
}

/// "35 kts", "1.5 NM^2"
String formatMagnitude(double value, String? unit) {
  final number = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return unit == null ? number : '$number $unit';
}
