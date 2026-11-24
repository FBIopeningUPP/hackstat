import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HackClubAuth {
  static const String _authUrl = 'https://auth.hackclub.com';
  static const String _clientId = 'hackstat_mobile'; // You'll need to register this
  static const String _redirectUri = 'hackstat://auth/callback';
  
  static const String _accessTokenKey = 'hc_access_token';
  static const String _refreshTokenKey = 'hc_refresh_token';
  static const String _userIdKey = 'hc_user_id';
  static const String _userNameKey = 'hc_user_name';
  static const String _userEmailKey = 'hc_user_email';

  /// Generate OAuth authorization URL
  static String getAuthorizationUrl() {
    final params = {
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'response_type': 'code',
      'scope': 'openid profile email name slack_id verification_status',
    };
    
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$_authUrl/oauth/authorize?$query';
  }

  /// Exchange authorization code for access token
  static Future<bool> exchangeCodeForToken(String code, String clientSecret) async {
    try {
      final response = await http.post(
        Uri.parse('$_authUrl/oauth/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'client_id': _clientId,
          'client_secret': clientSecret,
          'redirect_uri': _redirectUri,
          'code': code,
          'grant_type': 'authorization_code',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokens(
          data['access_token'],
          data['refresh_token'],
        );
        
        // Fetch user info
        await _fetchAndSaveUserInfo(data['access_token']);
        return true;
      }
    } catch (e) {
      print('Error exchanging code: $e');
    }
    return false;
  }

  /// Fetch user info from /api/v1/me
  static Future<void> _fetchAndSaveUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_authUrl/api/v1/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final identity = data['identity'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, identity['id'] ?? '');
        await prefs.setString(_userNameKey, 
            '${identity['first_name'] ?? ''} ${identity['last_name'] ?? ''}'.trim());
        await prefs.setString(_userEmailKey, identity['primary_email'] ?? '');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  /// Save tokens to secure storage
  static Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get stored user info
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_userIdKey),
      'name': prefs.getString(_userNameKey),
      'email': prefs.getString(_userEmailKey),
    };
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Refresh access token
  static Future<bool> refreshAccessToken(String clientSecret) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);
      
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$_authUrl/oauth/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'client_id': _clientId,
          'client_secret': clientSecret,
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokens(
          data['access_token'],
          data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }

  /// Sign out
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  /// Get Hackatime API key from Hack Club Auth token
  /// This assumes the user has linked their Hackatime account
  static Future<String?> getHackatimeApiKey() async {
    final token = await getAccessToken();
    if (token == null) return null;

    try {
      // Try to fetch Hackatime API key from user's profile
      // This would need to be implemented on Hackatime's side
      final response = await http.get(
        Uri.parse('https://hackatime.hackclub.com/api/v1/users/current/api_key'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['api_key'];
      }
    } catch (e) {
      print('Error fetching Hackatime API key: $e');
    }
    return null;
  }
}
