import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String baseUrl =
      'https://www.vakiletonline.ir/app/wp-json/legal/v1';

  static const String lawsUrl =
      'https://vakiletonline.ir/wp-json/wp/v2/posts?categories=1850';

  static String? _token;

  static String? get token => _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  static dynamic _decodeResponse(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }

    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {
        'status': false,
        'message': response.body,
      };
    }
  }

  static Future<dynamic> _get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      return _decodeResponse(response);
    } catch (e) {
      return {
        'status': false,
        'message': 'خطا در اتصال به سرور',
        'error': e.toString(),
      };
    }
  }

  static Future<dynamic> _post(
      String url,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _decodeResponse(response);
    } catch (e) {
      return {
        'status': false,
        'message': 'خطا در اتصال به سرور',
        'error': e.toString(),
      };
    }
  }

  static Future<dynamic> _put(
      String url,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _decodeResponse(response);
    } catch (e) {
      return {
        'status': false,
        'message': 'خطا در اتصال به سرور',
        'error': e.toString(),
      };
    }
  }

  static Future<dynamic> _delete(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _headers,
      );

      return _decodeResponse(response);
    } catch (e) {
      return {
        'status': false,
        'message': 'خطا در اتصال به سرور',
        'error': e.toString(),
      };
    }
  }

  // --------------------------------------------------
  // TEST API
  // --------------------------------------------------

  static Future<dynamic> testConnection() async {
    return _get('$baseUrl/test');
  }

  // --------------------------------------------------
  // REGISTER
  // --------------------------------------------------

  static Future<dynamic> register({
    required Map<String, dynamic> data,
  }) async {
    return _post(
      '$baseUrl/register',
      data,
    );
  }

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------

  static Future<dynamic> login({
    required Map<String, dynamic> data,
  }) async {
    final result = await _post(
      '$baseUrl/login',
      data,
    );

    if (result is Map<String, dynamic>) {
      final possibleToken =
          result['token'] ??
              result['access_token'] ??
              result['accessToken'];

      if (possibleToken != null &&
          possibleToken.toString().isNotEmpty) {
        _token = possibleToken.toString();

        debugPrint('API TOKEN RECEIVED');
      }
    }

    return result;
  }

  // --------------------------------------------------
  // PROFILE
  // --------------------------------------------------

  static Future<dynamic> getProfile() async {
    return _get('$baseUrl/profile');
  }

  // --------------------------------------------------
  // CONSULTATION
  // --------------------------------------------------

  static Future<dynamic> createConsultation({
    required Map<String, dynamic> data,
  }) async {
    return _post(
      '$baseUrl/consultation',
      data,
    );
  }

  // --------------------------------------------------
  // CONSULTATIONS
  // --------------------------------------------------

  static Future<dynamic> getConsultations() async {
    return _get('$baseUrl/consultations');
  }

  // --------------------------------------------------
  // UPDATE PROFILE
  // --------------------------------------------------

  static Future<dynamic> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    return _put(
      '$baseUrl/update-profile',
      data,
    );
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  static Future<dynamic> logout() async {
    final result = await _post(
      '$baseUrl/logout',
      {},
    );

    _token = null;

    return result;
  }

  // --------------------------------------------------
  // DELETE ACCOUNT
  // --------------------------------------------------

  static Future<dynamic> deleteAccount() async {
    final result = await _delete(
      '$baseUrl/delete-account',
    );

    _token = null;

    return result;
  }

  // --------------------------------------------------
  // LAWS
  // --------------------------------------------------

  static Future<dynamic> getLaws({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    String url =
        '$lawsUrl&page=$page&per_page=$perPage';

    if (search != null && search.trim().isNotEmpty) {
      url += '&search=${Uri.encodeQueryComponent(search.trim())}';
    }

    return _get(url);
  }
}