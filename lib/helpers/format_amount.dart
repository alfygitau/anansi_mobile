import 'package:intl/intl.dart';

String formatAmount(dynamic amount) {
  // Handle null or invalid inputs gracefully
  if (amount == null) return "KES 0.00";

  // Ensure the amount is a double (works if you pass int or String)
  final double value = double.tryParse(amount.toString()) ?? 0.0;

  final formatter = NumberFormat.currency(
    locale: 'en_KE', 
    symbol: 'KES ', 
    decimalDigits: 2,
  );

  return formatter.format(value);
}