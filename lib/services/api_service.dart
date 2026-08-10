import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
ApiService._();

// ============================================================
// BASE URLS
// ============================================================

static const String baseUrl =
'https://www.vakiletonline.ir/app/wp-json/legal/v1';

static const String lawsUrl =
'https://vakiletonline.ir/wp-json/wp/v2/posts';

// ============================================================
// TOKEN
// ============================================================

static String? _token;

static String? get token => _token;

static bool get isLoggedIn =>
_token != null && _token!.trim().isNotEmpty;

static void setToken(String token) {
_token = token.trim();
}

static void clearToken() {
_token = null;
}

// ============================================================
// HEADERS
// ============================================================

static Map<String, String> get _headers {
final headers = <String, String>{
'Content-Type': 'application/json',
'Accept': 'application/json',
};

if (isLoggedIn) {
headers['Authorization'] = 'Bearer $_token';
}

return headers;
}

// ============================================================
// RESPONSE
// ============================================================

static dynamic _decodeResponse(http.Response response) {
if (response.body.isEmpty) {
return {
'status': response.statusCode >= 200 &&
response.statusCode < 300,
};
}

dynamic data;

try {
data = jsonDecode(response.body);
} catch (_) {
data = {
'status': response.statusCode >= 200 &&
response.statusCode < 300,
'message': response.body,
};
}

if (data is Map<String, dynamic>) {
data['_httpStatus'] = response.statusCode;
data['_success'] =
response.statusCode >= 200 && response.statusCode < 300;
}

return data;
}

static Map<String, dynamic> _connectionError(Object error) {
debugPrint('API ERROR: $error');

return {
'status': false,
'success': false,
'message': 'خطا در اتصال به سرور. لطفاً اتصال اینترنت را بررسی کنید.',
'error': error.toString(),
};
}

// ============================================================
// GET
// ============================================================

static Future<dynamic> _get(String url) async {
try {
debugPrint('GET: $url');

final response = await http.get(
Uri.parse(url),
headers: _headers,
);

debugPrint('GET STATUS: ${response.statusCode}');

return _decodeResponse(response);
} catch (e) {
return _connectionError(e);
}
}

// ============================================================
// POST
// ============================================================

static Future<dynamic> _post(
String url,
Map<String, dynamic> data,
) async {
try {
debugPrint('POST: $url');
debugPrint('DATA: $data');

final response = await http.post(
Uri.parse(url),
headers: _headers,
body: jsonEncode(data),
);

debugPrint('POST STATUS: ${response.statusCode}');

return _decodeResponse(response);
} catch (e) {
return _connectionError(e);
}
}

// ============================================================
// PUT
// ============================================================

static Future<dynamic> _put(
String url,
Map<String, dynamic> data,
) async {
try {
debugPrint('PUT: $url');

final response = await http.put(
Uri.parse(url),
headers: _headers,
body: jsonEncode(data),
);

debugPrint('PUT STATUS: ${response.statusCode}');

return _decodeResponse(response);
} catch (e) {
return _connectionError(e);
}
}

// ============================================================
// DELETE
// ============================================================

static Future<dynamic> _delete(String url) async {
try {
debugPrint('DELETE: $url');

final response = await http.delete(
Uri.parse(url),
headers: _headers,
);

debugPrint('DELETE STATUS: ${response.statusCode}');

return _decodeResponse(response);
} catch (e) {
return _connectionError(e);
}
}

// ============================================================
// TEST CONNECTION
// ============================================================

static Future<dynamic> testConnection() async {
return _get('$baseUrl/test');
}

// ============================================================
// REGISTER
// ============================================================

static Future<dynamic> register({
required Map<String, dynamic> data,
}) async {
return _post(
'$baseUrl/register',
data,
);
}

// ============================================================
// LOGIN
// ============================================================

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
possibleToken.toString().trim().isNotEmpty) {
setToken(possibleToken.toString());

debugPrint('LOGIN SUCCESS - TOKEN RECEIVED');
}
}

return result;
}

// ============================================================
// PROFILE
// ============================================================

static Future<dynamic> getProfile() async {
return _get('$baseUrl/profile');
}

// ============================================================
// UPDATE PROFILE
// ============================================================

static Future<dynamic> updateProfile({
required Map<String, dynamic> data,
}) async {
return _put(
'$baseUrl/update-profile',
data,
);
}

// ============================================================
// CONSULTATION
// ============================================================

static Future<dynamic> createConsultation({
required Map<String, dynamic> data,
}) async {
return _post(
'$baseUrl/consultation',
data,
);
}

// ============================================================
// GET CONSULTATIONS
// ============================================================

static Future<dynamic> getConsultations() async {
return _get('$baseUrl/consultations');
}

// ============================================================
// LOGOUT
// ============================================================

static Future<dynamic> logout() async {
final result = await _post(
'$baseUrl/logout',
{},
);

clearToken();

return result;
}

// ============================================================
// DELETE ACCOUNT
// ============================================================

static Future<dynamic> deleteAccount() async {
final result = await _delete(
'$baseUrl/delete-account',
);

clearToken();

return result;
}

// ============================================================
// LAWS
// ============================================================

static Future<dynamic> getLaws({
int page = 1,
int perPage = 20,
String? search,
}) async {
final queryParameters = <String, String>{
'categories': '1850',
'page': page.toString(),
'per_page': perPage.toString(),
};

if (search != null && search.trim().isNotEmpty) {
queryParameters['search'] = search.trim();
}

final uri = Uri.parse(lawsUrl).replace(
queryParameters: queryParameters,
);

return _get(uri.toString());
}
}