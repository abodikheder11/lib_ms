import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/env.dart';
import '../../../../core/dio_client.dart';
import '../models/auth_user.dart';

class AuthRepository {
  AuthRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  String get _baseUrl => Env.baseUrl;

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
    bool isAuthor = false,
  }) async {
    final endpoint = isAuthor ? '/api/register-author' : '/api/register-user';

    final res = await http.post(
      ApiClient.url(endpoint),
      headers: ApiClient.defaultHeaders,
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'location': location,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    ).timeout(ApiClient.connectTimeout);

    final data = jsonDecode(res.body);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registration failed');
    }

    return data as Map<String, dynamic>;
  }
  Future<(AuthUser?, String?)> signIn({
    required String email,
    required String password,
    bool isAuthor = false,
  }) async {
    final endpoint = isAuthor ? '/api/login-author' : '/api/login-user';

    final res = await http.post(
      ApiClient.url(endpoint),
      headers: ApiClient.defaultHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(ApiClient.connectTimeout);

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'Login failed');
    }

    final user = data.containsKey('user')
        ? AuthUser.fromJson(data['user'])
        : null;

    final token = data['token'] as String?;
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
      await prefs.setBool('is_author', isAuthor);
    }
    return (user, token);
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/api/verify-email-user'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      await http.get(Uri.parse('$_baseUrl/sanctum/csrf-cookie'));
    } catch (_) {}

    final res = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: jsonEncode({'email': email}),
    );

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await http.get(Uri.parse('$_baseUrl/sanctum/csrf-cookie'));
    } catch (_) {}

    final res = await http.post(
      Uri.parse('$_baseUrl/reset-password'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: jsonEncode({
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> signOut() async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      );
    } catch (_) {}

    await clearToken();
  }
}
