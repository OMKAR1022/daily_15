import 'dart:convert';
import 'package:http/http.dart' as http;

class StreakService {
  /// Fetches the current user's streak information
  ///
  /// [baseUrl] - The base URL of the API
  /// [token] - The authentication token
  /// [userId] - Optional user ID to fetch streak for a specific user
  ///
  /// Returns a Map containing streak information
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> fetchUserStreak(
      String baseUrl,
      String token,
      {String? userId}
      ) async {
    // Use userId in URL if provided
    final url = userId != null
        ? Uri.parse('$baseUrl/api/v1/streaks/user/$userId')
        : Uri.parse('$baseUrl/api/v1/streaks/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Streak API Response Status: ${response.statusCode}');
      print('Streak API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication failed. Please log in again.');
      } else if (response.statusCode == 404) {
        throw Exception('Streak information not found.');
      } else {
        throw Exception('Failed to load streak information: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching streak information: $e');
      throw Exception('Error fetching streak information: $e');
    }
  }
}
