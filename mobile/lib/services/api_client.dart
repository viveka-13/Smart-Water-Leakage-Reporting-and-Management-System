import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/errors/app_exception.dart';

class ApiClient {
  ApiClient({String? baseUrl}) : _baseUrl = baseUrl ?? 'http://localhost:3001/api';

  final String _baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _send(() => http.get(
          uri,
          headers: _headers(token: token),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _send(() => http.post(
          _buildUri(path),
          headers: _headers(token: token, contentType: 'application/json'),
          body: body == null ? null : jsonEncode(body),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _send(() => http.put(
          _buildUri(path),
          headers: _headers(token: token, contentType: 'application/json'),
          body: body == null ? null : jsonEncode(body),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _send(() => http.patch(
          _buildUri(path),
          headers: _headers(token: token, contentType: 'application/json'),
          body: body == null ? null : jsonEncode(body),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    String? token,
  }) async {
    final response = await _send(() => http.delete(
          _buildUri(path),
          headers: _headers(token: token),
        ));
    return _handleResponse(response);
  }

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final uriString = '$_baseUrl$path';
    return Uri.parse(uriString).replace(queryParameters: queryParameters);
  }

  Map<String, String> _headers({String? token, String? contentType}) {
    final headers = <String, String>{};
    if (contentType != null) {
      headers['Content-Type'] = contentType;
    }
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 20));
    } on http.ClientException catch (error) {
      throw NetworkException(message: error.message);
    } on TimeoutException {
      throw const NetworkException(message: 'The server did not respond in time.');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = response.body.isEmpty ? {} : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    final error = decoded is Map ? decoded['error'] : null;
    final message = error is Map
        ? (error['message'] ?? 'Request failed.').toString()
        : decoded is Map
            ? (decoded['message'] ?? 'Request failed.').toString()
            : 'Request failed.';

    if (response.statusCode == 401) {
      throw UnauthorizedException(message: message);
    }

    if (response.statusCode == 404) {
      throw NotFoundException(message: message);
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ValidationException(message: message);
    }

    throw ServerException(message: message);
  }
}
