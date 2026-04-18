import 'package:intl/intl.dart';

String formatPostgresDateWithTime(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return "--";
  try {
    DateTime dateTime = DateTime.parse(createdAt).toLocal();
    return DateFormat('d MMM, yyyy • hh:mm a').format(dateTime);
  } catch (e) {
    return "Invalid Date";
  }
}