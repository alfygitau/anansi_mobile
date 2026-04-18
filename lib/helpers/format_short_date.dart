import 'package:intl/intl.dart';

String formatShortDate(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return "--";

  try {
    // Parse and ensure local timezone
    DateTime dateTime = DateTime.parse(createdAt).toLocal();

    // Formats to: 18 Apr, 2026
    return DateFormat('d MMM, yyyy').format(dateTime);
  } catch (e) {
    return "Invalid Date";
  }
}