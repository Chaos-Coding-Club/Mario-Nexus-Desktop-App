import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureJwtStorage {
  final FlutterSecureStorage _storage;
  static const String _jwtTokenKey = "jwt_token";
  static const String _userIdKey = "userId";
  String? _cachedJwt;
  int? _cachedUserId;

  SecureJwtStorage(this._storage);

  Future<String?> getJwt() async {
    if (_cachedJwt != null) {
      return _cachedJwt;
    }
    return _cachedJwt = await _storage.read(key: _jwtTokenKey);
  }

  Future<int?> getUserId() async {
    if (_cachedUserId != null) {
      return _cachedUserId;
    }
    final id = await _storage.read(key: _userIdKey);
    if (id == null) {
      return null;
    }
    try {
      return _cachedUserId = int.parse(id);
    } on FormatException {
      return null;
    }
  }

  Future<void> save(String token, int userId) {
    _cachedJwt = token;
    _storage.write(key: _jwtTokenKey, value: token);
    return _storage.write(key: _userIdKey, value: userId.toString());
  }

  Future<void> clear() {
    _cachedJwt = null;
    _cachedUserId = null;
    _storage.delete(key: _userIdKey);
    return _storage.delete(key: _jwtTokenKey);
  }
}
