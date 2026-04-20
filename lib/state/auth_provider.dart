import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;

  // Getters
  Map<String, dynamic>? get user => _user;

  // 1. Update User Method
  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    notifyListeners();
  }

  // 2. Logout Method
  void logout() {
    _user = null;
    notifyListeners();
  }
}
