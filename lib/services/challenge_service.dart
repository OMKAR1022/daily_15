import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/challenge.dart';


class ChallengeService {
  final String baseUrl;
  final String token;
  final String? userId;

  ChallengeService({
    required this.baseUrl,
    required this.token,
    this.userId,
  });

  Future<List<Challenge>> getTodayChallenges() async {
    try {
      // Use userId in URL if provided
      final url = userId != null
          ? Uri.parse('$baseUrl/api/v1/challenges/today/user/$userId')
          : Uri.parse('$baseUrl/api/v1/challenges/today');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Challenge API Response Status: ${response.statusCode}');
      print('Challenge API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> challengesJson = data['challenges'];

        return challengesJson.map((json) => Challenge.fromJson(json)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication error. Please log in again.');
      } else if (response.statusCode == 404) {
        throw Exception('No challenges found for today.');
      } else {
        throw Exception('Failed to load challenges: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in challenge service: $e');
      throw Exception('Failed to load challenges: $e');
    }
  }
}
