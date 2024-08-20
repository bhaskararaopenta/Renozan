import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/services/secure_storage_service.dart';
import 'package:app/services/service_locator.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  final String baseUrl;
  final SecureStorageService secureStorageService;

  ApiService(
      {required this.client,
      required this.baseUrl,
      required this.secureStorageService});

  Future<Map<String, dynamic>> performPostRequest(
      String endpoint, Map<String, dynamic> body) async {
    return await _checkNetworkAndExecute(() => _post(endpoint, body));
  }

  Future<Map<String, dynamic>> performGetRequest(
      String endpoint, Map<String, dynamic> params) async {
    return await _checkNetworkAndExecute(() => _get(endpoint, params));
  }

  Future<Map<String, dynamic>> _post(
      String endpoint, Map<String, dynamic> body) async {
    final fullUrl = '$baseUrl$endpoint';
    log.i('POST Request: $fullUrl, Body: $body');

    try {
      final response = await client.post(
        Uri.parse(fullUrl),
        body: jsonEncode(body),
        headers: await _buildHeaders(),
      );
      log.i('POST Response: ${response.statusCode}, Body: ${response.body}');
      return _processResponse(response);
    } on AppException {
      rethrow;
    } catch (e, s) {
      log.e('POST Request Error: $e');
      throw AppException(e.toString(), e.toString(), s);
    }
  }

  Future<Map<String, dynamic>> _get(
      String endpoint, Map<String, dynamic> params) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final fullUrl = uri.toString();
    log.i('GET Request: $fullUrl');

    try {
      final response = await client.get(
        uri,
        headers: await _buildHeaders(),
      );
      log.i('GET Response: ${response.statusCode}, Body: ${response.body}');
      return _processResponse(response);
    } on AppException {
      rethrow;
    } catch (e) {
      log.e('GET Request Error: $e');
      throw AppException(e.toString());
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    final accessToken =
        await secureStorageService.readKeyValue(SecureStorageKey.userAuthToken);
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _checkNetworkAndExecute(
      Future<Map<String, dynamic>> Function() request) async {
    if (await networkStatus.hasInternetAccess) {
      final response = await request();
      if (response['success'] == true) {
        return response;
      } else {
        throw ServerException(response['status'], response['message']);
      }
    } else {
      throw NoInternetException();
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final responseJson = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseJson;
    } else {
      throw ServerException(response.statusCode, responseJson['message']);
    }
  }
}
