import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> getUserAgent() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return 'Android ${androidInfo.model} (SDK ${androidInfo.version.sdkInt})';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return 'iOS ${iosInfo.utsname.machine} (${iosInfo.systemVersion})';
  }
  return 'Unknown Device';
}

Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'unknown';
  }
  return 'unknown';
}
