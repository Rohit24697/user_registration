import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = 'https://dummyjson.com/users';

class ApiService {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<dynamic> _makeRequest(
      String endpoint, {
        String method = 'GET',
        Map<String, dynamic>? body,
      }) async {
    if (!await checkInternetConnection()) {
      throw Exception('No Internet Connection');
    }

    final Uri url = Uri.parse('$kBaseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to $method data: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// ✅ Corrected login method using DummyJSON's login API
  static Future<Map<String, dynamic>> login(
      String username,
      String password,
      ) async {
    final response = await _makeRequest(
      'auth/login',
      method: 'POST',
      body: {
        'username': username,
        'password': password,
      },
    );

    return {
      'id': response['id'],
      'username': response['username'],
      'email': response['email'],
      'firstName': response['firstName'],
      'lastName': response['lastName'],
      'token': response['token'], // Optional: Store for auth later
    };
  }

  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    final response =
    await _makeRequest('users/add', method: 'POST', body: userData);
    return response;
  }

  static Future<List<dynamic>> getUserList() async {
    final response = await _makeRequest('users');
    return response['users'];
  }

  static Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    final response = await _makeRequest(
      'users/$userId',
      method: 'PUT',
      body: userData,
    );
    return response;
  }

  static Future<void> deleteUser(int userId) async {
    await _makeRequest('users/$userId', method: 'DELETE');
  }
}
