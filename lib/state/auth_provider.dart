import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _kycDetails;

  // Getters
  Map<String, dynamic>? get user => _user;
  Map<String, dynamic>? get kycDetails => _kycDetails;

  // 1. Update User Method
  void setUser(Map<String, dynamic> userData) {
    _user = userData;
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
