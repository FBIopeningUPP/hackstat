import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stats_model.dart';

class ApiService {
  static const String _apiKeyKey = 'hackatime_api_key';
  static const String _baseUrlKey = 'hackatime_base_url';
  static const String defaultBaseUrl = 'https://hackatime.hackclub.com';

  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  static Future<void> saveBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyKey);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final apiKey = await getApiKey();
    final encoded = base64Encode(utf8.encode(apiKey ?? ''));
    return {
      'Authorization': 'Basic $encoded',
      'Content-Type': 'application/json',
    };
  }

  static Future<bool> validateApiKey(String apiKey, {String? baseUrl}) async {
    try {
      final url = baseUrl ?? defaultBaseUrl;
      final encoded = base64Encode(utf8.encode(apiKey));
      
      // Use heartbeats endpoint for validation (POST with empty array)
      final response = await http.post(
        Uri.parse('$url/api/v1/users/current/heartbeats'),
        headers: {
          'Authorization': 'Basic $encoded',
          'Content-Type': 'application/json',
        },
        body: json.encode([]), // Empty heartbeats array
      ).timeout(const Duration(seconds: 10));

      // 201 = success, 401/403 = invalid key, anything else = server issue
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final baseUrl = await getBaseUrl();
      final headers = await _getHeaders();
      
      // Get summaries to verify API key works (we'll just check if it succeeds)
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/current/summaries?start=${DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0]}&end=${DateTime.now().toIso8601String().split('T')[0]}'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Return a basic user object since we don't have a dedicated user endpoint
        return {
          'username': 'User',
          'display_name': 'Hackatime User',
        };
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  static Future<HackatimeStats?> getStats({String range = 'last_7_days'}) async {
    try {
      final baseUrl = await getBaseUrl();
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/current/stats/$range'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HackatimeStats.fromJson(data);
      }
    } catch (e) {
      print('Error fetching stats: $e');
    }
    return null;
  }

  static Future<HackatimeStats?> getSummaries({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final baseUrl = await getBaseUrl();
      final headers = await _getHeaders();
      
      final startDate = start ?? DateTime.now().subtract(const Duration(days: 7));
      final endDate = end ?? DateTime.now();
      
      final startStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final endStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/current/summaries?start=$startStr&end=$endStr'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final summaries = data['data'] as List? ?? [];
        return HackatimeStats.fromSummaries(summaries);
      }
    } catch (e) {
      print('Error fetching summaries: $e');
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard({int page = 1}) async {
    try {
      final baseUrl = await getBaseUrl();
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/leaders?page=$page'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
    }
    return [];
  }
}
