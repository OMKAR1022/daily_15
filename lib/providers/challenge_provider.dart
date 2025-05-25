import 'package:flutter/material.dart';

import '../models/challenge.dart';
import '../services/challenge_service.dart';


class ChallengeProvider with ChangeNotifier {
  List<Challenge> _challenges = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  List<Challenge> get challenges => _challenges;
  Challenge? get currentChallenge => _challenges.isNotEmpty ? _challenges[0] : null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  // Initialize with mock data for development
  void initialize({String? userId}) {
    _userId = userId;
    print('ChallengeProvider initialized with userId: $_userId');
    _isLoading = false;
    notifyListeners();
  }

  // Fetch challenges from API
  Future<void> fetchTodayChallenges(String baseUrl, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final challengeService = ChallengeService(
        baseUrl: baseUrl,
        token: token,
        userId: _userId,
      );

      final challenges = await challengeService.getTodayChallenges();
      _challenges = challenges;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching challenges: $_error');
      notifyListeners();
    }
  }

  void updateProgress(String challengeId, int completedQuestions) {
    final index = _challenges.indexWhere((c) => c.challengeId == challengeId);
    if (index != -1) {
      final challenge = _challenges[index];
      final updatedChallenge = Challenge(
        challengeId: challenge.challengeId,
        date: challenge.date,
        subject: challenge.subject,
        difficulty: challenge.difficulty,
        totalQuestions: challenge.totalQuestions,
        questions: challenge.questions,
        completedQuestions: completedQuestions,
        expiresAt: challenge.expiresAt,
      );

      _challenges[index] = updatedChallenge;
      notifyListeners();
    }
  }

  // Methods to be implemented later for API integration
  Future<void> startChallenge(String challengeId) async {
    // API call will go here
  }

  Future<void> submitChallengeProgress(String challengeId, int progress) async {
    // API call will go here
  }
}
