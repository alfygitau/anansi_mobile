import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save any data (primitive or complex) by key
  Future<void> write(String key, dynamic value) async {
    final String encodedValue = _encodeValue(value);
    await _storage.write(key: key, value: encodedValue);
  }

  /// Read data as String (you decode if it's complex)
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Read and decode as object (Map, List, etc.)
  Future<dynamic> readDecoded(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    try {
      return jsonDecode(value);
    } catch (_) {
      return value;
    }
  }

  /// Delete a specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all keys
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Read all key-value pairs
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  /// Internal: Encode complex types to JSON
  String _encodeValue(dynamic value) {
    if (value is String || value is num || value is bool) {
      return value.toString();
    } else {
      return jsonEncode(value);
    }
  }
}
