import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/dio_client.dart';
import '../models/auth_user.dart';

class AuthRepository {
  AuthRepository({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? DioClient.instance,
        _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> _saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, dynamic>> signUp({
    required String firstname,
    required String lastname,
    required String email,
    required String location,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await _dio.post(
      '/api/register-user',
      data: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'location': location,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    final data = _asMap(res.data);

    if (data.containsKey('token')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
    }

    return data;
  }



  Future<(AuthUser?, String?)> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/login-user',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = _asMap(res.data);

    if (data.containsKey('token')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
    }

    final user = data.containsKey('user')
        ? AuthUser.fromJson(data['user'])
        : null;

    final token = data['token'] as String?;

    return (user, token);
  }


  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final res = await _dio.post(
      '/api/verify-email-user',
      data: {
        'email': email,
        'code': code,
      },
    );
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      await _dio.get('/sanctum/csrf-cookie');
    } catch (_) {}

    final res = await _dio.post(
      '/forgot-password',
      data: {'email': email},
      options: Options(headers: {'X-Requested-With': 'XMLHttpRequest'}),
    );
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dio.get('/sanctum/csrf-cookie');
    } catch (_) {}

    final res = await _dio.post(
      '/reset-password',
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      options: Options(headers: {'X-Requested-With': 'XMLHttpRequest'}),
    );
    return _asMap(res.data);
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/logout');
    } catch (_) {
    }
    await clearToken();
    _dio.options.headers.remove('Authorization');
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map<String, dynamic> ? data : json.decode(json.encode(data)) as Map<String, dynamic>;

  String? _extractToken(Map<String, dynamic> data) {
    if (data['token'] is String) return data['token'] as String;
    if (data['access_token'] is String) return data['access_token'] as String;
    if (data['data'] is Map && (data['data']['token'] is String)) return data['data']['token'] as String;
    if (data['meta'] is Map && (data['meta']['token'] is String)) return data['meta']['token'] as String;
    return null;
  }

  Map<String, dynamic>? _guessUserMap(Map<String, dynamic> data) {
    final candidates = [
      data['user'],
      data['data'],
      data['payload'],
    ];
    for (final c in candidates) {
      if (c is Map && (c['email'] != null || c['id'] != null)) {
        return c.cast<String, dynamic>();
      }
    }
    return null;
  }


}
