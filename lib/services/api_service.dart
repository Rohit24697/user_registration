import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = 'https://dummyjson.com/users';
const String kReqResUrl = 'https://reqres.in/api/users'; // For optional dummy registration

class ApiService {
  /// Check Internet Connection
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Internal request handler
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

  /// DummyJSON API Login
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
      'token': response['token'],
    };
  }

  /// Register user via DummyJSON (for real testing)
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    final response =
    await _makeRequest('add', method: 'POST', body: userData);
    return response;
  }

  /// Register user via ReqRes (alternative dummy API)
  static Future<Map<String, dynamic>> registerUserViaReqRes(
      Map<String, dynamic> userData) async {
    if (!await checkInternetConnection()) {
      throw Exception('No Internet Connection');
    }

    final url = Uri.parse(kReqResUrl);
    final response = await http.post(
      url,
      body: jsonEncode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Failed to register via ReqRes'};
    }
  }

  /// Get user list from DummyJSON
  static Future<List<dynamic>> getUserList() async {
    final response = await _makeRequest('');
    return response['users'];
  }

  /// Update user by ID
  static Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    final response = await _makeRequest(
      '$userId',
      method: 'PUT',
      body: userData,
    );
    return response;
  }

  /// Delete user by ID
  static Future<void> deleteUser(int userId) async {
    await _makeRequest('$userId', method: 'DELETE');
  }
}

