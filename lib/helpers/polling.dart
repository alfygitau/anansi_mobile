import 'dart:async';

Future<bool> polling({
  required Future<bool> Function() apiCallback,
  Duration interval = const Duration(seconds: 3),
  Duration timeout = const Duration(seconds: 25),
}) async {
  final DateTime endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    try {
      final bool isSuccessful = await apiCallback();

      if (isSuccessful) {
        return true;
      }
    } catch (e) {
      print("Polling attempt failed: $e");
    }
    await Future.delayed(interval);
  }

  return false;
}
