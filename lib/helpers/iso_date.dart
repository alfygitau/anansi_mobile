String convertToISODate(String? dob) {
  if (dob == null || dob.isEmpty) return "";
  final parts = dob.split(RegExp(r'\D+'));
  if (parts.length != 3) {
    return dob;
  }
  final day = parts[0].padLeft(2, '0');
  final month = parts[1].padLeft(2, '0');
  final year = parts[2];
  return "$year-$month-$day";
}
