import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _kycDetails;
  bool _useBiometrics = true;

  // Getters
  Map<String, dynamic>? get kycDetails => _kycDetails;
  bool get useBiometrics => _useBiometrics;

  Future<void> setBiometricPreference(bool value) async {
    _useBiometrics = value;
    notifyListeners();
  }

  void setKyc(Map<String, dynamic> kycInfo) {
    _kycDetails = kycInfo;
    notifyListeners();
  }

  // 2. Logout Method
  void logout() {
    _kycDetails = null;
    notifyListeners();
  }
}
