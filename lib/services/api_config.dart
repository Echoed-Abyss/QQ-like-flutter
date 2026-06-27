import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String tcpHost = '10.0.2.2';
  static const int tcpPort = 9090;
  static const String appSecret = 'qq-like-server-app-secret-2024';
  static const String apiVersion = '/api/v1';
}

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _keyToken = 'user_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: _keyUserId, value: userId.toString());
  }

  static Future<int?> getUserId() async {
    final id = await _storage.read(key: _keyUserId);
    return id != null ? int.tryParse(id) : null;
  }

  static Future<void> saveUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: _keyUsername);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

class SignatureUtil {
  static String generateSignature(String data, int timestamp, String nonce) {
    final hmacSha256 = Hmac(sha256, utf8.encode(ApiConfig.appSecret));
    final signData = '$data:$timestamp:$nonce';
    final digest = hmacSha256.convert(utf8.encode(signData));
    return digest.toString();
  }

  static String generateNonce() {
    return '${DateTime.now().millisecondsSinceEpoch}${DateTime.now().microsecond}';
  }

  static int getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}
