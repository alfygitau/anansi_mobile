import 'dart:convert';
import 'dart:io';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final SecureStorageService _storage = SecureStorageService();

  Future<String> getBiometricStatus() async {
    String? status = await _storage.read("biometric_status");
    return status ?? "isEnabled";
  }

  Future<void> setBiometricStatus(bool enable) async {
    String status = enable ? "isEnabled" : "isDisabled";
    await _storage.write("biometric_status", status);
  }

  Future<bool> hasSavedToken() async {
    try {
      String? token = await _storage.read('accessToken');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await _storage.read('user');
    if (userJson == null) return null;
    try {
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<bool> canUseBiometrics() async {
    try {
      final String isCurrentlyEnabled = await getBiometricStatus();
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _auth
          .getAvailableBiometrics();
      final bool hasToken = await hasSavedToken();
      final user = await getUser();
      final bool userAvailable = user != null && user.containsKey("id");

      return isDeviceSupported &&
          canCheckBiometrics &&
          availableBiometrics.isNotEmpty &&
          hasToken &&
          userAvailable &&
          isCurrentlyEnabled == "isEnabled";
    } catch (e) {
      debugPrint("Biometric support check failed: $e");
      return false;
    }
  }

  Future<IconData?> getBiometricIcon() async {
    final LocalAuthentication auth = LocalAuthentication();
    List<BiometricType> availableBiometrics = await auth
        .getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      return Platform.isIOS
          ? LucideIcons.scanFace
          : Icons.face_retouching_natural;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    }
    return null;
  }

  Future<bool> authenticateUser() async {
    try {
      return await _auth.authenticate(
        localizedReason:
            'Please authenticate to securely access your Anansi account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Anansi Security',
            biometricHint: 'Verify identity',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(cancelButton: 'Cancel'),
        ],
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> runProtectedAction({
    required Function onActionSuccess,
    Function? onActionFail,
  }) async {
    bool isAuthenticated = await authenticateUser();

    if (isAuthenticated) {
      onActionSuccess();
    } else {
      if (onActionFail != null) {
        onActionFail();
      }
    }
  }
}
