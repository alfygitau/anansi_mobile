String? formatToKenyanPhone(String phone) {
  String cleaned = phone.replaceAll(RegExp(r'\D'), '');

  // Normalize formats
  if (cleaned.startsWith('0')) {
    cleaned = '254${cleaned.substring(1)}';
  } else if (cleaned.length == 9 && (cleaned.startsWith('7') || cleaned.startsWith('1'))) {
    cleaned = '254$cleaned';
  } else if (cleaned.startsWith('2540')) {
    cleaned = '254${cleaned.substring(4)}';
  }

  // VALIDATION: Kenyan numbers must be 254 + (7 or 1) + 8 digits = 12 characters
  final kenyanRegex = RegExp(r'^254[71][0-9]{8}$');
  
  if (kenyanRegex.hasMatch(cleaned)) {
    return cleaned;
  }

  return null; // Return null if it's not a valid Kenyan mobile
}